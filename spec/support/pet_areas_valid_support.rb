module PetAreasValidSupport
  def transfer_areas(available_area)
    areas = build_list(:pet_area, available_area , pet_id: pet.id)
    @pet_areas = AreaForm.new
    @pet_areas.areas = areas
    @pet_areas.valid?
  end
end

RSpec.configure do |config|
  config.include PetAreasValidSupport
end