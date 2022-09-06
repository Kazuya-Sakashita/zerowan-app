class Pet < ApplicationRecord
  has_many :pet_images, dependent: :destroy
  belongs_to :uer
  accepts_nested_attributes_for :pet_images, allow_destroy: true


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

