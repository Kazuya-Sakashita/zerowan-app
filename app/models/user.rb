class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

         has_one :profile, dependent: :destroy
         accepts_nested_attributes_for :profile, allow_destroy: true


      with_options presence: true do
        # validates :password, on: :create
        # validates :password_confirmation, on: :create
        with_options uniqueness: true do
          validates :email
        end
    end
end
