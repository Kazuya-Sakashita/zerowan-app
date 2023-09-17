class Room < ApplicationRecord
  has_many :messages, -> { order(created_at: :desc) }, dependent: :destroy # メッセージは作成日時で降順に並べる
  belongs_to :pet
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_one :latest_message, -> { order(created_at: :desc).limit(1) }, class_name: 'Message'

  validate :different_user_and_owner


  def recipient(current_user)
    current_user == user ? owner : user
  end

  private

  def different_user_and_owner
    errors.add(:owner_id, :different_user_and_owner) if user_id == owner_id
  end
end
