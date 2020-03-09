class DefinitionParser
  KEYWORD = '$pf-meta:'

  def parse(definition)
    case definition
    when String
      handle_text(definition)
    when Hash
      definition.map { |key, value| [key, parse(value)] }.to_h
    when Array
      definition.map { |value| parse(value) }
    else
      definition
    end
  end

  private
  def parse_query_text(text)
    return nil unless text.start_with? KEYWORD
    text[KEYWORD.length..-1]
  end

  def handle_query_text(query)
    uri = URI(query)
    raise ArgumentError, "Unknown $pf-meta function name: #{uri.path}" if uri.path != "passthrough"

    URI.decode_www_form(uri.query).to_h['value']
  end

  def handle_text(text)
    query = parse_query_text(text)
    return text if query.nil?

    handle_query_text(query)
  end
end
