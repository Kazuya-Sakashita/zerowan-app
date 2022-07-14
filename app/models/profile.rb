class Profile < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :name
    validates :address
    validates :phoneNumber
    validates :birthday
    validates :breedingExperience
  end
end
