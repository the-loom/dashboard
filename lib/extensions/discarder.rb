module Extensions
  class Discarder
    # redirect_path is a fallback for when class name has a module prefix. Use it wisely.
    def self.new(entity_class, redirect_path = nil)
      Module.new do
        define_method(:destroy) do
          authorize entity_class, :manage?
          entity = entity_class.find(params[:id])
          entity.discard
          flash[:success] = "Se eliminó correctamente"
          redirect_to redirect_path || { controller: entity_class.name.downcase.pluralize, action: :index }
        end

        define_method(:bin) do
          authorize entity_class, :manage?
          @entities = entity_class.discarded
        end

        define_method(:restore) do
          authorize entity_class, :manage?
          entity = entity_class.find(params[:id])
          entity.undiscard
          flash[:success] = "Se restauró correctamente"
          redirect_to redirect_path || { controller: entity_class.name.downcase.pluralize, action: :index }
        end
      end
    end
  end
end
