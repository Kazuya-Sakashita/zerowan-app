class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable, :confirmable

  has_one :profile, dependent: :destroy
  has_one :profile_image, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, dependent: :destroy
  

  accepts_nested_attributes_for :profile, allow_destroy: true
  accepts_nested_attributes_for :profile_image, allow_destroy: true

  with_options presence: true do
    with_options uniqueness: true do
      validates :email
    end
  end

  def is_owner?
    self.role == 'owner'
  end

  # def latest_messages
  #   @latest_messages = current_user.rooms.joins(:messages).group('rooms.id').maximum('messages.created_at')
  #   @rooms_cust = @latest_messages.map do |room_id, latest_created_at|
  #   Message.find_by(room_id: room_id, created_at: latest_created_at)
  #   end.sort_by { |message| message.created_at }.reverse
  # end
end
