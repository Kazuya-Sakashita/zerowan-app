class PetForm
  include ActiveModel::Model

  attr_accessor :photos

  validates :photos, presence: true

  validate :validates_number_of_files
  # FILE_NUMBER_LIMIT = 4 #枚数制限（最大数）

  def validates_number_of_files
    binding.pry

    # 枚数に関係なくひかかる、保存されない
    @photos.present? && @photos.length < 5
      errors.add(:@photos, '添付枚数は４枚までです。')

    # 枚数で分岐するが保存されない
    # unless @photos.present? && @photos.length < 5
    # errors.add(:@photos, '添付枚数は４枚までです。')
    # end


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
    binding.pry
    raise ActiveRecord::RecordInvalid.new(self) if invalid?

    @photos.each(&:save!)
  end
end