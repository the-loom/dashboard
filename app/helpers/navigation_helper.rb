module NavigationHelper
  def nav_ensure
    @navigation ||= [ ]
  end

  def nav_add(title, url)
    nav_ensure << { title: title, url: url }
  end

  def nav_render
    content_for(:title, ((nav_ensure.reverse.map { |nav| nav[:title] }).join(" < ")))
    render partial: "shared/navigation", locals: { nav: nav_ensure }
  end

  def nav_render4
    content_for(:title, ((nav_ensure.reverse.map { |nav| nav[:title] }).join(" < ")))
    render partial: "shared/navigation4", locals: { nav: nav_ensure }
  end
end
