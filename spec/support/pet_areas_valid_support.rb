module PetAreasValidSupport
  def transfer_areas(areas)
    @pet_areas = AreaForm.new
    @pet_areas.areas = areas
    @pet_areas.valid?
  end
end

RSpec.configure do |config|
  config.include PetAreasValidSupport
end