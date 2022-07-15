class Profile < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :name
    validates :address
    validates :phone_number
    validates :birthday
    validates :breeding_experience
  end
end
