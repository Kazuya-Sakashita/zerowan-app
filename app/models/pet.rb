class Pet < ApplicationRecord
  belongs_to :user
  has_many :pet_images, dependent: :destroy
  accepts_nested_attributes_for :pet_images

  with_options presence: true do
    validates :name
  end

  enum gender: { オス: 1, メス: 2, 不明: 3 }
  enum castration: { 有: 1, 無: 0 }, _prefix: true
  enum vaccination: { 有: 1, 無: 0 }, _prefix: true
end
