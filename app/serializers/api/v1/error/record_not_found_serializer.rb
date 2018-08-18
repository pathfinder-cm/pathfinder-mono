class ::Api::V1::Error::RecordNotFoundSerializer < ::Api::V1::Error::BaseSerializer
  def error
    hsh = super
    hsh.merge!({
      resource: resource_class,
      message: @object.message,
      errors: [
        message: @object.message
      ]
    })
    hsh.merge!({backtrace: @object.backtrace})

    hsh
  end

  def resource_class
    @object.message.split(" ", 4)[2]
  end
end
