class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable, :confirmable

  has_one :profile, dependent: :destroy
  has_one :profile_image, dependent: :destroy
  has_many :pets
  has_many :favorites, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms

  accepts_nested_attributes_for :profile, allow_destroy: true
  accepts_nested_attributes_for :profile_image, allow_destroy: true

  with_options presence: true do
    with_options uniqueness: true do
      validates :email
    end
  end
end
