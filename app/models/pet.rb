class Pet < ApplicationRecord
  has_many :pet_images, dependent: :destroy
  accepts_nested_attributes_for :pet_images, allow_destroy: true


  with_options presence: true do
    validates :petname
    validates :category
    validates :introduction
    validates :gender
    validates :age
    validates :classification
    validates :castration
    validates :vaccination
  end
end

