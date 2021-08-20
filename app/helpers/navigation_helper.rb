module NavigationHelper
  def nav_ensure
    @navigation ||= [ ]
  end

  def nav_add(title, url)
    nav_ensure << { title: title, url: url }
  end

  # Bootstrap 3
  def nav_render
    set_title
    render partial: "shared/navigation", locals: { nav: nav_ensure }
  end

  # Bootstrap 4
  def nav_render4
    set_title
    render partial: "shared/navigation4", locals: { nav: nav_ensure }
  end

  # Bootstrap 5
  def nav_render5
    nav_render4
  end

  private
    def set_title
      @title = nav_ensure.reverse.map { |nav| nav[:title] }
    end
end
