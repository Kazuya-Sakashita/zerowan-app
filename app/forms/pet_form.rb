class PetForm
  include ActiveModel::Model

  attr_accessor :photos, :pet_id
  delegate :persisted?, to: :post

  def initialize(attributes = nil, post: PetImage.new)
    attributes ||= default_attributes
    super(attributes)
  end

  def save!

    binding.pry
    return if invalid?


  end

  private

  attr_reader :pet_images
  def default_attributes
    {
      photos: @photos,
      pet_id: @pet_id
    }
  end

end


