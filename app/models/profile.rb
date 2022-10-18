class Profile < ApplicationRecord
  belongs_to :user
  has_one :profile_image, dependent: :destroy

  VALID_PHONE_REGEX = /\A\d{10}$|^\d{11}\z/

  with_options presence: true do
    validates :name
    validates :address
    validates :phone_number, format: { with: VALID_PHONE_REGEX }
    validates :birthday
    validates :breeding_experience
  end
end
