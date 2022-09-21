class PetForm
  include ActiveModel::Model

  attr_accessor :photos, :pet_id



  def save!

    return if invalid?

    @photos = []
    pet_images.reject(&:blank?)&.each do |image|
      @photos << PetImage.new(photo: image, pet_id: pet_id)
    end
  end

  private


end


