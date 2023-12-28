class Area < ApplicationRecord
  has_many :pet_areas, dependent: :destroy
  has_many :pets, through: :pet_areas

  validates :place_name, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
end
