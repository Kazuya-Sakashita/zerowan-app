class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_one :profile, dependent: :destroy
  has_one :profile_image, dependent: :destroy
  has_many :pets


  accepts_nested_attributes_for :profile, allow_destroy: true
  accepts_nested_attributes_for :profile_image, allow_destroy: true


  with_options presence: true do
    with_options uniqueness: true do
      validates :email
    end
  end
end
