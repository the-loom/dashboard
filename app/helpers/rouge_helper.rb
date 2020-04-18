module RougeHelper
  def rouge(text, language)
    text.present? ? formatter.format(lexer(language).lex(text)) : text
  end
  
  private

  def formatter
    Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight')
  end

  def lexer language
    Rouge::Lexer.find(language)
  end
end