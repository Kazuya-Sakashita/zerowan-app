class PetImage < ApplicationRecord
  belongs_to :pet
  accepts_nested_attributes_for :pet, allow_destroy: true
end
