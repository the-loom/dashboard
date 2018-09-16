class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :change_identity]
  before_action :verify_pending_solutions, only: :show
  before_action :verify_name, only: :show

  def index
    authorize User
    @students = Course.current.memberships.student.collect { |x| x.user }

    @lectures = Lecture.all
    @teams = Team.all
    @badges = Badge.all
    @events = Event.all
  end

  def guests
    authorize User
    @guests = Course.current.memberships.guest.collect { |x| x.user }
  end

  def show
    if params[:nickname]
      unless @user = Course.current.memberships.includes(:user).where(users: { nickname: params[:nickname] }).first.try(:user)
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
    unless @user = Course.current.memberships.includes(:user).where(users: { nickname: params[:nickname] }).first.try(:user)
      flash[:alert] = "No existe el usuario"
      return redirect_to "/"
    end
    authorize @user, :comment?
    @user.comments.create(body: params[:comment][:body], commenter: current_user, mood: params[:comment][:mood].to_i)
    redirect_to user_details_url(@user.nickname)
  end

  def impersonate
    @user = User.where(nickname: params[:nickname]).first
    authorize @user, :impersonate?
    session[:user_id] = @user.id
    redirect_to profile_url
  end

  def disable
    user = User.where(nickname: params[:nickname]).first
    authorize user, :manage?
    current_membership = user.current_membership
    current_membership.enabled = !current_membership.enabled?
    current_membership.save
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
    identity = @user.identities.where(id: params[:identity_id]).first
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

    if params[:bulk_edit][:action].present?
      #TODO(delucas): decide upon params[:bulk_edit][:action] value
      students = User.where(id: student_ids)


      if params[:bulk_edit][:action] == 'assign_badge'
        badge = Badge.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Badge, :register?
        if MassiveBadgeAssigner.new(students, badge).execute
          flash[:info] = "Se asignaron correctamente #{students.size} emblemas del tipo #{badge.name}"
        end
      end

      if params[:bulk_edit][:action] == 'register_event'
        event = Event.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Event, :register?
        if MassiveEventRegister.new(students, event).execute
          flash[:info] = "Se registraron correctamente #{students.size} eventos del tipo #{event.name}"
        end
      end

      if params[:bulk_edit][:action] == 'join_profiles'
        authorize User, :manage?
        if ProfileJoiner.new(students).execute
          flash[:info] = "Se unieron correctamente #{students.size} perfiles"
        end
      end

      if params[:bulk_edit][:action] == 'attendance'
        lecture = Lecture.find(params[:bulk_edit][:auxiliary_id].to_i)

        authorize Lecture, :register?
        if MassiveAttendanceRegister.new(students, lecture).execute
          flash[:info] = "Se dio el presente a #{students.size} estudiantes en la clase #{lecture.summary}"
        end
      end

      redirect_to students_url
      return
    end

    if params[:mark_as_guest]
      role = :guest
    elsif params[:mark_as_teacher]
      role = :teacher
    elsif params[:mark_as_student]
      role = :student
    end
    Course.current.memberships.where("user_id IN (?)", student_ids).update_all(role: role)
    redirect_to students_url
  end

  private

    def set_user
      @user ||= current_user
    end

    def user_params
      params[:user].permit(:first_name, :last_name)
    end
end
