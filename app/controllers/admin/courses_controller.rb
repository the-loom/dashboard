module Admin
  class CoursesController < ApplicationController
    def index
      @enabled_courses = Course.enabled
      @disabled_courses = Course.disabled
    end

    def duplicate
      authorize Course, :admin?
      base_course = Course.find(params[:id])

      @course = base_course.fully_duplicate!

      @labels = OpenStruct.new(title: "Editar curso", button: "Actualizar curso")
      render :form
    end

    def rotate_password
      authorize Course, :admin?
      course = Course.find(params[:id])
      course.rotate_password
      course.save

      redirect_to edit_admin_course_path(course)
    end

    def replicate
      authorize Course, :admin?
      base_course = Course.find(params[:id])

      @course = base_course.replicate!
      @course.replica = true
      @course.parent_course = base_course
      @course.save

      @labels = OpenStruct.new(title: "Editar curso", button: "Actualizar curso")
      render :form
    end

    def new
      authorize Course, :admin?
      @course = Course.new
      @labels = OpenStruct.new(title: "Nuevo curso", button: "Guardar curso")
      render :form
    end

    def create
      authorize Course, :admin?
      @course = Course.new(course_params)

      if @course.valid?
        @course.save
        redirect_to admin_courses_path
        flash[:info] = "Se creó correctamente el curso"
      else
        @labels = OpenStruct.new(title: "Nuevo curso", button: "Guardar curso")
        render :form
      end
    end

    def edit
      authorize Course, :admin?
      @course = Course.find(params[:id])
      @labels = OpenStruct.new(title: "Editar curso", button: "Actualizar curso")
      render :form
    end

    def update
      authorize Course, :admin?
      @course = Course.find(params[:id])

      if @course.update(course_params)
        redirect_to admin_courses_path
        flash[:info] = "Se editó correctamente el curso"
      else
        @labels = OpenStruct.new(title: "Editar curso", button: "Actualizar curso")
        render :form
      end
    end

    def destroy
      course = Course.find(params[:id])
      authorize course, :admin?
      course.discard

      redirect_to admin_courses_path
    end

    def restore
      course = Course.find(params[:id])
      authorize course, :admin?
      course.undiscard

      redirect_to admin_courses_path
    end

    def toggle
      authorize Course, :admin?
      course = Course.find(params[:id])
      course.update_attribute(:enabled, !course.enabled?)
      redirect_to admin_courses_path
    end

    private
      def course_params
        features = params[:course][:features].present? ? params[:course][:features].map(&:to_i).inject(0, :|) : 0

        {
            name: params[:course][:name],
            password: params[:course][:password],
            features: features,
            attendance_event_id: params[:course][:attendance_event_id],
            registrable: params[:course][:registrable]
        }
      end
  end
end
