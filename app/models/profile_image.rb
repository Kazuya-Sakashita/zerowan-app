class ProfileImage < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :user

  # validates :avatar ,presence: true
  validates :user_id, uniqueness: true

  def avatar

  end
end
