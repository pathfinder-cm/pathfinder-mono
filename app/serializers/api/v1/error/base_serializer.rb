class ::Api::V1::Error::BaseSerializer < ::Api::V1::BaseSerializer
  def initialize(object)
    super(object)
    @error_ident = "#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}".upcase
    @time = DateTime.current
  end

  def attributes
    (super - [:data]) | [:error]
  end

  def error
    hsh = {
      # Error identification number.
      error_ident: @error_ident,

      # The primary descriptive error message - either in the primary language
      # of the server or translated into a language negotiated via the HTTP
      # header "Accept-Language".
      message: @object.message,

      # An optional list of descriptive error messages.
      messages: [],

      # An optional descriptive text targeted at the client developer.
      details: [],

      # Container for any additional information regarding the error. If the
      # service returns multiple errors, each element in the errors array
      # represents a different error.
      errors: [
        message: @object.message
      ],

      # Timestamp of when the error occurred.
      time: (@time || DateTime.current),

      # An optional list of links to other resources that can be helpful for
      # debugging.
      links: []
    }

    hsh
  end
end
