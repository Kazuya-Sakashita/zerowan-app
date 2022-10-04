class PetForm
  include ActiveModel::Model

  attr_accessor :photos

  with_options presence: true do
    validates :photo
    validates :pet_id
  end


  validate :validates_number_of_files
  FILE_NUMBER_LIMIT = 4 #枚数制限（最大数）

  def validates_number_of_files
    #@photos.lengthで制限をかける
    @photos.present? && @photos.length <= FILE_NUMBER_LIMIT
  end

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