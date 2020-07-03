class UsersController < ApplicationController
  layout "application2", only: [:edit]

  before_action :set_user, only: [:edit, :update, :change_identity]
  before_action :verify_name, only: :show

  def index
    authorize User
    @students = User.kept.includes(:memberships).includes(avatar_attachment: :blob).where(memberships: { course: Course.current, role: :student })

    # Just for massive actions
    @lectures = Lecture.all.order(date: :asc)
    @teams = Team.all.order(name: :asc)
    @badges = Badge.all
    @events = Event.all.order(name: :asc) - [Course.current.attendance_event]
    @score_calculator = ScoreCalculator.new

    respond_to do |format|
      format.html
      format.csv do
        send_data User.to_csv, filename: "attendance_sheet.csv"
      end
    end
  end

  def show
    if params[:nickname]
      unless @user = Course.current.memberships.includes(:user).find_by(users: { nickname: params[:nickname] }).try(:user)
        flash[:alert] = "No existe el usuario"
        return redirect_to "/"
      end
    else
      @user = current_user
    end
    @missing_badges = Badge.all - @user.badges
    authorize @user
  end

  def comment
    unless @user = Course.current.memberships.includes(:user).find_by(users: { nickname: params[:nickname] }).try(:user)
      flash[:alert] = "No existe el usuario"
      return redirect_to "/"
    end
    authorize @user, :comment?
    @user.comments.create(body: params[:comment][:body], commenter: current_user, mood: params[:comment][:mood].to_i)
    redirect_to user_details_url(@user.nickname)
  end

  def toggle
    user = User.find(params[:id])
    authorize user, :manage?
    current_membership = user.current_membership
    current_membership.enabled = !current_membership.enabled?
    current_membership.save
    redirect_to students_path
  end

  def destroy
    # TODO: migrate to membership#destroy ? students#destroy ?
    user = User.find(params[:id])
    authorize user, :manage?
    user.current_membership.discard

    redirect_to students_path
  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user, :update?
    if @user.update(user_params)
      redirect_to profile_url
    else
      render :edit
    end
  end

  def change_identity
    authorize @user, :update?
    identity = @user.identities.find_by(id: params[:identity_id])
    @user.update_with(identity)
    redirect_to profile_url
  end

  def bulk_edit
    if !params[:students].present? || !params[:students][:ids].present?
      flash[:info] = "Debes seleccionar al menos a un estudiante para asignar una acción masiva"
      redirect_to students_url
      return
    end

    student_ids = params[:students][:ids].map(&:to_i)
    multiplier = params[:bulk_edit][:times].to_i
    multiplier = multiplier == 0 ? 1 : multiplier

    if params[:bulk_edit][:action].present?
      # TODO(delucas): decide upon params[:bulk_edit][:action] value
      students = User.where(id: student_ids)

      if params[:bulk_edit][:action] == "assign_badge"
        badge = Badge.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Badge, :register?
        if MassiveBadgeAssigner.new(students, badge).execute
          flash[:success] = "Se asignaron correctamente #{students.size} emblemas del tipo #{badge.name}"
        end
      end

      if params[:bulk_edit][:action] == "register_event"
        event = Course.current.events.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Event, :register?

        lecture = params[:bulk_edit][:lecture_id].present? ? Lecture.find(params[:bulk_edit][:lecture_id]) : nil
        if MassiveEventRegister.new(students, event, multiplier, lecture).execute
          flash[:success] = "Se registraron correctamente #{multiplier} eventos del tipo #{event.name} para #{students.size} estudiantes"
        end
      end

      if params[:bulk_edit][:action] == "join_profiles"
        authorize User, :manage?
        if ProfileJoiner.new(students).execute
          flash[:success] = "Se unieron correctamente #{students.size} perfiles"
        end
      end

      if params[:bulk_edit][:action] == "attendance"
        lecture = Lecture.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Lecture, :register?
        if MassiveAttendanceRegister.new(students, lecture).execute
          flash[:success] = "Se dio el presente a #{students.size} estudiantes en la clase #{lecture.summary}"
        end
      end

      if params[:bulk_edit][:action] == "promote"

        authorize current_user, :promote?
        if MassiveTeacherPromoter.new(students).execute
          flash[:success] = "Se promovieron #{students.size} Estudiantes al rol Docente"
        end
      end

      if params[:bulk_edit][:action] == "team"
        team = Course.current.teams.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Team, :add_member?
        if MassiveTeamRegister.new(students, team).execute
          flash[:success] = "Se agregaron #{students.size} estudiantes en el equipo #{team.name}"
        end
      end

      redirect_to students_url
      nil
    end
  end

  private
    def set_user
      @user ||= current_user
    end

    def user_params
      params[:user].permit(:first_name, :last_name, :avatar)
    end
end
