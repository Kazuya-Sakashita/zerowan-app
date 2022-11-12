class Area < ApplicationRecord
  has_many :pet_areas, dependent: :destroy
  has_many :pets, :through => :pet_areas
end
