class PetForm
  include ActiveModel::Model

  attr_accessor :photos


  def save!
    return if invalid?
    binding.pry
    #ここでpetに紐づいての登録にしなければならない。
    # pet.pet_images.buildを使用していたが、フォームを分割したため使えない。
    # 紐づける方法
    photos.each do |photo|
      PetImage.create(photo: photo)
    end
    # pet.save! ? true : false
  end

end
