class PetForm
  include ActiveModel::Model


  # attr_accessor :category, :petname, :introduction, :gender, :age, :classification, :castration, :vaccination, :recruitment_status,
  #               :user_id, :pet_images


  attr_accessor :photos

  def save!
        return false if invalid?
        pet = Pet.new(
          category: category,
          petname: petname,
          introduction: introduction,
          gender: gender,
          age: age,
          classification: classification,
          castration: castration,
          vaccination: vaccination,
          recruitment_status: recruitment_status,
          user_id: user_id,
          recruitment_status:0
        )
        photos.each do |photo|
            pet.pet_images.build(photo: photo).save!
          end

        pet.save! ? true : false
      end

end