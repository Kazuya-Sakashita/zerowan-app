class PetForm
  include ActiveModel::Model

  attr_accessor :photos

  validate :validates_number_of_files

  def validates_number_of_files
    if 1 > photos.length || photos.length > 4
      errors.add(:photos, '添付枚数を確認してください。')
    end
  end

  def initialize(pet_id: nil, pet_images: [])
    @photos = []
    pet_images.reject(&:blank?)&.each do |image|
      @photos << PetImage.new(photo: image, pet_id: pet_id)
    end
  end

  def save!
    # save!,期待値を保存できない場合に例外を発生させる
    # 登録内容に不備がある場合はActiveRecord::RecordInvalid、invalidの場合発生させる

    raise ActiveRecord::RecordInvalid.new(self) if invalid?
    @photos.each(&:save!)
  end
end