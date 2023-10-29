require 'rails_helper'

RSpec.feature 'admins/users/show', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:pet) { create(:pet, user_id: user.id) }

  before do
    sign_in admin
    visit admins_users_path
    click_link '詳細'
  end

  scenario 'ユーザー詳細ページを表示する' do
    expect(page).to have_content('ユーザー詳細')
  end

  scenario 'プロフィール詳細が表示されていること' do
    expect(page).to have_content user.profile.name
    expect(page).to have_content user.profile.address
    expect(page).to have_content user.profile.phone_number
    expect(page).to have_content user.profile.birthday.strftime('%Y年%m月%d日')
    expect(page).to have_content user.profile.breeding_experience
    expect(page).to have_content user.profile.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
    expect(page).to have_content "#{user.pets.size} 件"
  end

  expect(page).to have_link('詳細', href: admins_pet_path(pet.id))
  expect(page).to have_link('削除', href: admins_pet_path(pet.id))
end
