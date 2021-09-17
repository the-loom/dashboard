module TagHelper
  def show_tags(tags)
    render partial: "shared/tags", locals: { tags: tags }
  end
end
