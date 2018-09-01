class ::Api::BaseSerializer < ApplicationSerializer
  def initialize(object, attrs: {}, total_server_items: 0, notifications: [])
    @object = object
    @attrs = attrs
    @total_server_items = total_server_items
    @notifications = notifications
  end

  def attributes
    [
      :api_version,
      :notifications,
      :data
    ]
  end

  def notifications
    @notifications.map do |notification|
      {
        field: notification.field, 
        message: notification.message, 
        type: notification.type,
      }
    end
  end

  def to_h
    serialized_hash = {}
    attributes.each do |attribute|
      serialized_hash[attribute] = self.send(attribute)
    end

    serialized_hash
  end
end
