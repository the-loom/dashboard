module Admin
  class CoursesController < ApplicationController
    def index
      @courses = Course.all
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
        render action: :new
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

      if @course.update_attributes(course_params)
        redirect_to admin_courses_path
        flash[:info] = "Se editó correctamente el curso"
      else
        render action: :edit
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
      course.update_attributes(enabled: !course.enabled?)
      redirect_to admin_courses_path
    end

    private

      def course_params
        features = params[:course][:features].present? ? params[:course][:features].map(&:to_i).inject(0, :|) : 0

        {
            name: params[:course][:name],
            features: features
        }
      end
  end
end
