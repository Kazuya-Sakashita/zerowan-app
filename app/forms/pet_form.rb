class PetForm
  include ActiveModel::Model

  attr_accessor :photos, :pet_id

  def initialize(attributes = {})
    photos = attributes[:photos]
    pet_id = attributes[:pet_id]
    @pet_image = []
    photos.reject(&:blank?)&.each do |image|
      @pet_image << PetImage.new(photo: image, pet_id: pet_id)
    end
  end

  def save!
    @pet_image.each(&:save!)
  end

  private

end


