require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'バリデーション' do
    it 'petname 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, petname: nil)
      pet.valid?
      expect(pet.errors[:petname]).to include('を入力してください')
    end
    it 'category 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, category: nil)
      pet.valid?
      expect(pet.errors[:category]).to include('を入力してください')
    end
    it 'introduction 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, introduction: nil)
      pet.valid?
      expect(pet.errors[:introduction]).to include('を入力してください')
    end
    it 'gender 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, gender: nil)
      pet.valid?
      expect(pet.errors[:gender]).to include('を入力してください')
    end
    it 'age 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, age: nil)
      pet.valid?
      expect(pet.errors[:age]).to include('を入力してください')
    end
    it 'classification 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, classification: nil)
      pet.valid?
      expect(pet.errors[:classification]).to include('を入力してください')
    end
    it 'castration 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, castration: nil)
      pet.valid?
      expect(pet.errors[:castration]).to include('を入力してください')
    end
    it 'vaccination 値がない場合にバリデーションエラーが発生すること' do
      pet = build(:pet, vaccination: nil)
      pet.valid?
      expect(pet.errors[:vaccination]).to include('を入力してください')
    end
  end
end