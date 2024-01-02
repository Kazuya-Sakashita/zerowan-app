class PetArea < ApplicationRecord
  belongs_to :pet
  belongs_to :area

  validates :pet_id, presence: true
  validates :area_id, presence: true

  validates :pet_id, uniqueness: { scope: :area_id }
end
