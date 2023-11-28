require 'rails_helper'

RSpec.feature 'admins/pets/index', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:pets) { create_list(:pet, 2, user:) }

  before do
    sign_in admin
    visit admins_pets_path
  end

  scenario 'ユーザー一覧ページを表示する' do
    expect(page).to have_content('里親募集')
  end

  scenario '里親募集画面の表示内容の確認' do
    within 'tbody' do
      expect(page).to have_selector("img[src$='#{pets.second.pet_images.first.photo.url}']")
      expect(page).to have_content(pets.first.petname)
      expect(page).to have_content(pets.first.recruitment_status)
      expect(page).to have_content(pets.first.user.profile.name)
      expect(page).to have_content(pets.first.created_at.strftime('%Y-%m-%d %H:%M:%S'))
    end

    expect(page).to have_link('詳細', href: admins_pet_path(pets.first.id))
    expect(page).to have_link('削除', href: admins_pet_path(pets.first.id))
  end

  scenario 'ページネーションが表示される' do
    expect(page).to have_selector('.pagination')
    pagination_text = page.find('.pagination').text
    expect(pagination_text).to include('1', '2', 'Next', 'Last')
  end
end
