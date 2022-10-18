class Pet < ApplicationRecord

  has_many :pet_images, dependent: :destroy
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

  enum gender: [:unknown, :male, :female ]
  enum category: [:dog, :cat, :others], _prefix: true
  enum classification: [:Chihuahua, :Dachshund, :others], _prefix: true
  enum vaccination: [:unknown, :vaccinated, :unvaccinated] , _prefix: true
  enum castration: [:unknown, :neutered, :unneutered ],  _prefix: true

end