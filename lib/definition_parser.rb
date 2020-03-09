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
  module MethodCatalog
    extend self

    def passthrough(value: )
      value
    end
  end

  def parse_query_text(text)
    return nil unless text.start_with? KEYWORD
    text[KEYWORD.length..-1]
  end

  def handle_query_text(query)
    handle_query_uri URI(query)
  end

  def handle_query_uri(uri)
    method_name = uri.path.to_sym
    method_params = URI.decode_www_form(uri.query).to_h.symbolize_keys

    unless MethodCatalog.public_methods.include? method_name
      raise ArgumentError, "Unknown $pf-meta function name: #{method_name}"
    end
    MethodCatalog.public_send method_name, **method_params
  end

  def handle_text(text)
    query = parse_query_text(text)
    return text if query.nil?

    handle_query_text(query)
  end
end
