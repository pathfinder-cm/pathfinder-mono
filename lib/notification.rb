class Notification
  attr_accessor :field, :message, :type

  def initialize(field, message, type)
    @field = field
    @message = message
    @type = type
  end
end
