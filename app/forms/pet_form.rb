class PetForm
  include ActiveModel::Model

  attr_accessor :photos, :pet_id


  def save!

    binding.pry
    # pet.save! ? true : false
  end

end


