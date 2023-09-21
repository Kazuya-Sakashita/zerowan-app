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

  describe '#new?' do
    let(:pet) { build(:pet, created_at: created_at) }

    context 'ペットが6日以内に作成された場合' do
      let(:created_at) { 5.days.ago }

      it 'trueを返すこと' do
        expect(pet.new?).to be_truthy
      end
    end

    context 'ペットがちょうど6日後の23:59に作成された場合' do
      let(:created_at) { 6.days.ago.change(hour: 23, min: 59) }

      it 'trueを返すこと' do
        expect(pet.new?).to be_truthy
      end
    end

    context 'ペットがちょうど7日00:00に作成された場合' do
      let(:created_at) { 7.days.ago.change(hour: 0, min: 0) }

      it 'falseを返すこと' do
        expect(pet.new?).to be_falsey
      end
    end

    context 'ペットが6日より前に作成された場合' do
      let(:created_at) { 7.days.ago }

      it 'falseを返すこと' do
        expect(pet.new?).to be_falsey
      end
    end
  end
end