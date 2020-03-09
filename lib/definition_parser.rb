class DefinitionParser
  KEYWORD = '$pf-meta:'

  def parse(definition)
    case definition
    when String
      handle_text(definition)
    when Hash
      definition.map { |key, value| [key, parse(value)] }.to_h
    else
      definition
    end
  end

  private
  def parse_query(text)
    return nil unless text.start_with? KEYWORD
    text[KEYWORD.length..-1]
  end

  def handle_query(query)
    uri = URI(query)
    URI.decode_www_form(uri.query).to_h['value']
  end

  def handle_text(text)
    query = parse_query(text)
    return text if query.nil?

    handle_query(query)
  end
end
