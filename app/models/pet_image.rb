class PetImage < ApplicationRecord
  mount_uploader :photo, PetImageUploader
  belongs_to :pet

end
