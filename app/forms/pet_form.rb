class PetForm
  include ActiveModel::Model

  attr_accessor :photo, :pet_id
  delegate :persisted?, to: :post

  # def initialize(attributes = nil, post: PetImage.new)
  #   attributes ||= default_attributes
  #   super(attributes)
  # end

  def save!

    return if invalid?

    photos.each do |image|
      if image.present? #渡ってきたデータの配列最初が''のため、空保存しないため
        PetImage.create(photo: image, pet_id: pet_id)
      end
    end

  end

  private


end


