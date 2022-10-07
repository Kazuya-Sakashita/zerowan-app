class PetForm
  include ActiveModel::Model

  attr_accessor :photos

  validates :photos, presence: true

  validate :validates_number_of_files
  # FILE_NUMBER_LIMIT = 5 #枚数制限（最大数）

  def validates_number_of_files
    #@photos.lengthで制限をかける
    binding.pry
    @photos.present? && @photos.length < 5
    errors.add(:@photos, '添付枚数は４枚までです。')
    return false
  end

  def initialize(pet_id: nil, pet_images: [])
    @photos = []
    pet_images.reject(&:blank?)&.each do |image|
      @photos << PetImage.new(photo: image, pet_id: pet_id)
    end
  end

  def save!
    binding.pry
    return false if invalid?
    @photos.each(&:save!)
    end
end
