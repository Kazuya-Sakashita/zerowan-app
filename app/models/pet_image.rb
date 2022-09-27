class PetImage < ApplicationRecord
  mount_uploader :photo, PetImageUploader
  belongs_to :pet
  with_options presence: true do
    validates :photo
    validates :pet_id
  end
end
