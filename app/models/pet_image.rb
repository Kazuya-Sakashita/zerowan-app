class PetImage < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :pet
end
