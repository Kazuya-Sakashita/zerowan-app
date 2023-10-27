require 'rails_helper'

RSpec.feature 'admins/pets/index', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:pet) { create(:pet, user:) }
  let!(:pets) { create_list(:pet, 21, user:) }

  before do
    sign_in admin
    visit admins_pets_path
  end

  scenario 'ユーザー一覧ページを表示する' do
    expect(page).to have_content('里親募集')
  end

  scenario '里親募集画面の表示内容の確認' do
    within 'tbody' do
      expect(page).to have_selector("img[src$='#{pet.pet_images.first.photo.url}']")
      expect(page).to have_content(pet.petname)
      expect(page).to have_content(pet.recruitment_status)
      expect(page).to have_content(pet.user.profile.name)
      expect(page).to have_content(pet.created_at.strftime('%Y-%m-%d %H:%M:%S'))
    end

    expect(page).to have_link('詳細', href: '#')
    expect(page).to have_link('削除', href: admins_pet_path(pet.id))
  end

  scenario 'ページネーションが表示される' do
    expect(page).to have_selector('.pagination')

    # ページネーションのページ数の検証
    pagination_text = page.text.split("\n").last
    expect(pagination_text).to include('1', '2', 'Next', 'Last')
  end
end
