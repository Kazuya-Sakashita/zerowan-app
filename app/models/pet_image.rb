class PetImage < ApplicationRecord
  mount_uploaders :photos, PetImagesUploader
  serialize :photos, JSON
  belongs_to :pet

end
