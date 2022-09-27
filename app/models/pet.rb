class Pet < ApplicationRecord
  has_many :pet_images, dependent: :destroy
  accepts_nested_attributes_for :pet_images
  # accepts_nested_attributes_for :pet_images, allow_destroy: true
  belongs_to :user

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

  enum :gender, { unknown: 0, male: 1, female: 2 }, prefix: true
  enum :category, { dog: 0, cat: 1, others: 2 }, prefix: true
  enum :classification, { Chihuahua: 0, Dachshund: 1, others: 2 }, prefix: true
  enum :vaccination, { unknown: 0, vaccinated: 1, unvaccinated: 2 }, prefix: true
  enum :castration, { unknown: 0, neutered: 1, unneutered: 2 }, prefix: true

end

