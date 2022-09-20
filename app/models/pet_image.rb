class PetImage < ApplicationRecord
  mount_uploader :photo, PetImagesUploader
  belongs_to :pet

end
