class FaqsController < ApplicationController
  layout "application2"

  before_action do
    check_feature(:faqs)
  end

  def index
    authorize Faq, :use?
    @faqs = Faq.all
  end

  def new
    authorize Faq, :manage?
    @faq = Faq.new
    @labels = OpenStruct.new(title: "Nueva pregunta frecuente", button: "Guardar pregunta frecuente")
    render :form
  end

  def create
    authorize Faq, :manage?
    @faq = Faq.new(faq_params)
    if @faq.valid?
      @faq.save
      redirect_to faqs_path
      flash[:success] = "Se creó correctamente la pregunta frecuente"
    else
      @labels = OpenStruct.new(title: "Nueva pregunta frecuente", button: "Guardar pregunta frecuente")
      render :form
    end
  end

  def edit
    authorize Faq, :manage?
    @faq = Faq.find(params[:id])
    @labels = OpenStruct.new(title: "Editar pregunta frecuente", button: "Actualizar pregunta frecuente")
    render :form
  end

  def update
    authorize Faq, :manage?
    @faq = Faq.find(params[:id])

    if @faq.update_attributes(faq_params)
      redirect_to faqs_path
      flash[:success] = "Se editó correctamente la pregunta frecuente"
    else
      @labels = OpenStruct.new(title: "Editar pregunta frecuente", button: "Actualizar pregunta frecuente")
      render action: :edit
    end
  end

  private
    def faq_params
      params[:faq].permit(:question, :answer, :tag_list)
    end
end
