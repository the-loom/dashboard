class Publisher

  # redirect_path is a fallback for when class name has a module prefix. Use it wisely.
  def self.new(entity_class, redirect_path = nil)
    Module.new do

      define_method(:publish) do
        authorize entity_class, :manage?
        entity = entity_class.find(params[:id])
        entity.publish!

        redirect_to redirect_path || { controller: entity_class.name.downcase.pluralize, action: :index }
      end

      define_method(:unpublish) do
        authorize entity_class, :manage?
        entity = entity_class.find(params[:id])
        entity.unpublish!

        redirect_to redirect_path || { controller: entity_class.name.downcase.pluralize, action: :index }
      end
    end
  end

end
