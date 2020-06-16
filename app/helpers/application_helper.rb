module ApplicationHelper
  def page_title(separator = " | ")
    title = content_for(:title) || @title || "LoomDashboard"
    [title, "LoomDashboard"].flatten.compact.join(separator)
  end

  def entity_avatar(entity)
    if entity.avatar.attached?
      entity.avatar.variant(auto_orient: true)
    elsif entity.respond_to?(:image) && entity.image.present?
      entity.image
    else # fallback
      "https://avatars1.githubusercontent.com/u/20347933?s=400&v=4"
    end
  end

  def yes_no(bool_value)
    bool_value ? "Si" : "No"
  end

  def checkmark(bool_value)
    render "shared/checkmark", value: bool_value
  end
end
