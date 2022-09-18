class PetImage < ApplicationRecord
  mount_uploader :photo, PetImagesUploader
  serialize :photo, JSON
  belongs_to :pet

end
