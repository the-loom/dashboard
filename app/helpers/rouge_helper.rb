module RougeHelper
  def rouge(text, language)
    formatter.format(lexer(language).lex(text))
  end
  
  private

  def formatter
    Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight')
  end

  def lexer language
    Rouge::Lexer.find(language)
  end
end