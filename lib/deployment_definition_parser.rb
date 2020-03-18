class DeploymentDefinitionParser
  KEYWORD = '$pf-meta:'

  def parse(context, definition)
    case definition
    when String
      handle_text(context, definition)
    when Hash
      definition.map { |key, value| [key, parse(context, value)] }.to_h
    when Array
      definition.map { |value| parse(context, value) }
    else
      definition
    end
  end

  private
  def parse_query_text(text)
    return nil unless text.start_with? KEYWORD
    text[KEYWORD.length..-1]
  end

  def handle_query_text(context, query)
    handle_query_uri context, URI(query)
  end

  def handle_query_uri(context, uri)
    method_name = uri.path.to_sym
    method_params = URI.decode_www_form(uri.query.to_s).to_h.symbolize_keys

    unless context.public_methods.include? method_name
      raise ArgumentError, "Unknown $pf-meta function name: #{method_name}"
    end

    if method_params.empty?
      context.public_send method_name
    else
      context.public_send method_name, **method_params
    end
  end

  def handle_text(context, text)
    query = parse_query_text(text)
    return text if query.nil?

    handle_query_text(context, query)
  end
end
