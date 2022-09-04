class Pet < ApplicationRecord
  has_many :pet_images
  with_options presence: true do
    validates :name
    validates :category
    validates :introduction
    validates :gender
    validates :age
    validates :classification
    validates :castration
    validates :vaccination
  end
end
