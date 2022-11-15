class AreaForm
  include ActiveModel::Model

  attr_accessor :areas


  validate :validates_number_of_areas

  def validates_number_of_areas
    if 1 > areas.length || areas.length > 47
      errors.add(:areas, '入力を確認してください。')
    end
  end
  def initialize(pet_id: nil, pet_areas: [])
    @areas = []
    pet_areas.reject(&:blank?)&.each do |area|
      @areas << PetArea.new(area_id: area, pet_id: pet_id)
    end
  end

  def save!
    raise ActiveRecord::RecordInvalid.new(self) if invalid?
    @areas.each(&:save!)
  end
end