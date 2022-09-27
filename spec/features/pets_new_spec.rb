require 'rails_helper'

RSpec.feature '里親募集（登録）', type: :feature do
  let(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  before do
    sign_in user
    visit new_pet_path
  end

  describe '里親募集登録' do
    context '正常系' do
      scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
        expect(page).to have_content '紹介画像'
        expect(page).to have_content 'カテゴリ'
        expect(page).to have_content 'ペットのお名前'
        expect(page).to have_content '年齢'
        expect(page).to have_content '種別'
        expect(page).to have_content 'ペットのご紹介'
        expect(page).to have_content 'ワクチン接種有無'
        expect(page).to have_content '去勢有無'

        expect(page).to have_field 'pet_form[photos][]'
        expect(page).to have_field 'pet[category]'
        expect(page).to have_field 'pet[petname]'
        expect(page).to have_field 'pet[age]'
        expect(page).to have_field 'pet[classification]'
        expect(page).to have_field 'pet[introduction]'
        expect(page).to have_field 'pet[vaccination]'
        expect(page).to have_field 'pet[castration]'
        expect(page).to have_button '登録内容確認'
      end
    end
  end
end