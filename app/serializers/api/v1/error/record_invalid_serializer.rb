class ::Api::V1::Error::RecordInvalidSerializer < ::Api::V1::Error::BaseSerializer
  def error
    hsh = super
    hsh.merge!({
      resource: @object.record.class.to_s,
      message: @object.message,
      errors: errors
    })
    hsh.merge!({backtrace: @object.backtrace})

    hsh
  end

  def errors
    arr = []
    @object.record.errors.each do |field, message|
      arr << {
        field: field,
        message: message
      }
    end

    arr
  end
end
