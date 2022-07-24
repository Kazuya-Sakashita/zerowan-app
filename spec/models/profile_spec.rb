require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:user) { build(:user) }

  describe 'バリデーション' do
    context 'profile' do
      it 'name 値がない場合にバリデーションエラーが発生すること' do
        profile = build(:profile, user: user, name: nil)
        profile.valid?
        expect(profile.errors[:name]).to include('入力されていません。')
      end

      it 'address 値がない場合にバリデーションエラーが発生すること' do
        profile = build(:profile, user: user, address: nil)
        profile.valid?
        expect(profile.errors[:address]).to include('入力されていません。')
      end

      it 'phone_number 値がない場合にバリデーションエラーが発生すること' do
        profile = build(:profile, user: user, phone_number: nil)
        profile.valid?
        expect(profile.errors[:phone_number]).to include('入力されていません。')
      end

      it 'phone_number ９桁に満たない場合にバリデーションエラーが発生すること' do
        phone_number = "0" * 9
        profile = build(:profile, user: user, phone_number: phone_number)
        profile.valid?
        expect(profile.errors[:phone_number]).to include('が無効です。')
      end

      it 'phone_number １２桁より多い場合にバリデーションエラーが発生すること' do
        phone_number = "0" * 12
        profile = build(:profile, user: user, phone_number: phone_number)
        profile.valid?
        expect(profile.errors[:phone_number]).to include('が無効です。')
      end

      it 'phone_number 文字列が入っていた場合にバリデーションエラーが発生すること' do
        phone_number = "123456789z"
        profile = build(:profile, user: user, phone_number: phone_number)
        profile.valid?
        expect(profile.errors[:phone_number]).to include('が無効です。')
      end

      it 'birthday 値がない場合にバリデーションエラーが発生すること' do
        profile = build(:profile, user: user, birthday: nil)
        profile.valid?
        expect(profile.errors[:birthday]).to include('入力されていません。')
      end

      it 'breeding_experience 値がない場合にバリデーションエラーが発生すること' do
        profile = build(:profile, user: user, breeding_experience: nil)
        profile.valid?
        expect(profile.errors[:breeding_experience]).to include('入力されていません。')
      end
    end
  end
end
