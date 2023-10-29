require 'rails_helper'

RSpec.feature 'admins/pets/show', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:pet) { create(:pet, user:) }

  before do
    sign_in admin
    visit admins_pets_path
    click_link '詳細'
  end

  scenario 'ペット詳細ページを表示する' do
    expect(page).to have_content('里親募集詳細')
  end

  scenario '里親募集詳細が表示されていること' do
    within 'tbody' do
      pet.pet_images.each do |image|
        expect(page).to have_selector("img[src$='#{image.photo.url}']")
      end
      expect(page).to have_content pet.petname
      expect(page).to have_content pet.category_i18n
      expect(page).to have_content pet.user.profile.name
      expect(page).to have_content pet.gender_i18n
      expect(page).to have_content "#{pet.age}才"
      expect(page).to have_content pet.classification_i18n
      expect(page).to have_content pet.introduction
      expect(page).to have_content pet.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
    end
  end
end
