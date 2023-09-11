class Room < ApplicationRecord
  has_many :messages, -> { order(created_at: :desc) }, dependent: :destroy # メッセージは作成日時で降順に並べる
  belongs_to :pet
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :messages, -> { order(created_at: :desc)}
  has_one :latest_message, -> { order(created_at: :desc).limit(1) }, class_name: 'Message'

  def self.petname_extraction(room_id)
    @room = Room.find(room_id)
    @pet = @room.pet
  end
end
