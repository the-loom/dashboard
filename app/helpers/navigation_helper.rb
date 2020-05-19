module NavigationHelper
  def nav_ensure
    @navigation ||= [ ]
  end

  def nav_add(title, url)
    nav_ensure << { title: title, url: url }
  end

  def nav_render
    render partial: "shared/navigation", locals: { nav: nav_ensure }
  end

  def nav_render4
    render partial: "shared/navigation4", locals: { nav: nav_ensure }
  end
end
