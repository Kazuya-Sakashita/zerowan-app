class Pet < ApplicationRecord

  has_many :pet_images, dependent: :destroy
  has_many :pet_areas, dependent: :destroy
  has_many :areas, through: :pet_areas
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :rooms

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
  enum recruitment_status: [:recruiting, :during_negotiations, :end_of_recruitment ]

  def own?(viewer)
    user == viewer
  end

  def favorite?(viewer)
    favorites.detect{ |user| user.user_id == viewer.id }.present?
  end
end