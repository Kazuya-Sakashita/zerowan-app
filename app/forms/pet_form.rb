class PetForm
  include ActiveModel::Model

  attr_accessor :photos

  def initialize(pet_id: nil, pet_images: [])
    @photos = []
    pet_images.reject(&:blank?)&.each do |image|
      @photos << PetImage.new(photo: image, pet_id: pet_id)
    end
  end


  def save!
    @photos.each(&:save!)
  end

  private


end


