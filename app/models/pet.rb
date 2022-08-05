class Pet < ApplicationRecord
  has_many :pet_images, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :pet_images

  with_options presence: true do
    validates :name
    end
end
