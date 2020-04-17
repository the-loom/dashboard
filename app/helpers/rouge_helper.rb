module RougeHelper
  def rouge(text, language)
      text.gsub(/(<pre>(.*?)<\/pre>)/m) do
      content = CGI.unescapeHTML($2)
      content = formatter.format(lexer(language).lex(content))
      content.gsub('err', 'nf')
    end
  end
  private

    def formatter
      Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight')
    end

    def lexer language
      Rouge::Lexer.find(language)
    end
end