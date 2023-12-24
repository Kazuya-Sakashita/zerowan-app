class Pet < ApplicationRecord
  has_many :pet_images, dependent: :destroy
  has_many :pet_areas, dependent: :destroy
  has_many :areas, through: :pet_areas
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :rooms
  has_one :pickup

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

  enum gender: { unknown: 0, male: 1, female: 2 }
  enum category: { dog: 0, cat: 1, others: 2 }, _prefix: true
  enum classification: { Chihuahua: 0, Dachshund: 1, others: 2 }, _prefix: true
  enum vaccination: { unknown: 0, vaccinated: 1, unvaccinated: 2 }, _prefix: true
  enum castration: { unknown: 0, neutered: 1, unneutered: 2 }, _prefix: true
  enum recruitment_status: { recruiting: 0, negotiating: 1, family_decided: 2 }

  def own?(viewer)
    user == viewer
  end

  def favorite?(viewer)
    favorites.detect { |user| user.user_id == viewer.id }.present?
  end

  def new?
    end_of_new_period = (created_at + 6.days).end_of_day
    Time.now <= end_of_new_period
  end
end
