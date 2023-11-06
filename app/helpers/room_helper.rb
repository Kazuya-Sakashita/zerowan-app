module RoomHelper
  def new_messages?(room_id)
    $redis.sismember("user:#{current_user.id}:unread_messages_in_rooms", room_id)
  end
end
