class PetImage < ApplicationRecord
  mount_uploaders :photos, PetImageUploader
  serialize :photos, JSON
  belongs_to :pet

end
