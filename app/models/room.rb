class Room < ApplicationRecord
  has_many :messages, -> { order(created_at: :desc) }, dependent: :destroy # メッセージは作成日時で降順に並べる
  belongs_to :pet
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  def latest_message
    messages.first # 最新のメッセージを取得(並べ変え後に１つ目のメッセージを取得)
  end

  def self.petname_extraction(room_id)
    @room = Room.find(room_id)
    @pet = @room.pet
  end
end
