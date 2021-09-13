module NavigationHelper
  def nav_ensure
    @navigation ||= [ ]
  end

  def nav_add(title, url)
    nav_ensure << { title: title, url: url }
  end

  def nav_render5
    set_title
    render partial: "shared/navigation5", locals: { nav: nav_ensure }
  end

  private
    def set_title
      @title = nav_ensure.reverse.map { |nav| nav[:title] }
    end
end
