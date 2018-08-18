class ::Api::V1::Error::StandardErrorSerializer < ::Api::V1::Error::BaseSerializer
  def error
    hsh = super
    hsh.merge!({
      message: @object.message,
      errors: [
        message: @object.message
      ]
    })
    hsh.merge!({backtrace: @object.backtrace})

    hsh
  end
end
