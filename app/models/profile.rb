class Profile < ApplicationRecord
    belongs_to :user

    validates :name, presence: true
    validates :address, presence: true
    validates :phoneNumber, presence: true
    validates :birthday, presence: true
    validates :breedingExperience, presence: true
    
end

