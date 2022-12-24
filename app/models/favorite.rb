class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates_uniqueness_of :pet_id, scope: :user_ids
end
