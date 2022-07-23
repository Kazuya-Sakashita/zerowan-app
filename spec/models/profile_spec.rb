require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:profile) { FactoryBot.build(:profile, user_id: user.id) }

  describe 'バリデーション' do
    context 'profile' do
      it 'name 値がない場合にバリデーションエラーが発生すること' do
        profile.name = ""
        profile.valid?
        expect(profile.errors[:name]).to include('入力されていません。')
      end

      it 'address 値がない場合にバリデーションエラーが発生すること' do
        profile.address = ""
        profile.valid?
        expect(profile.errors[:address]).to include('入力されていません。')
      end

      it 'phone_number 値がない場合にバリデーションエラーが発生すること' do
        profile.phone_number = ""
        profile.valid?
        expect(profile.errors[:phone_number]).to include('入力されていません。')
      end
      it 'phone_number 文字列が入っていた場合にバリデーションエラーが発生すること' do
        profile.phone_number = "123456789z"
        profile.valid?
        expect(profile.errors[:phone_number]).to include('が無効です。')
      end

      it 'birthday 値がない場合にバリデーションエラーが発生すること' do
        profile.birthday = ""
        profile.valid?
        expect(profile.errors[:birthday]).to include('入力されていません。')
      end

      it 'breeding_experience 値がない場合にバリデーションエラーが発生すること' do
        profile.breeding_experience = ""
        profile.valid?
        expect(profile.errors[:breeding_experience]).to include('入力されていません。')
      end
    end
  end
end
