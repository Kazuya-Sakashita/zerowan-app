class PetArea < ApplicationRecord
  belongs_to :pet
  belongs_to :area
end
