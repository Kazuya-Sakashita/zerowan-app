require 'rails_helper'

RSpec.feature 'admins/home/index', type: :feature do
  describe 'GET /index' do
    let(:admin) { create(:admin) }

    let!(:joined_users) do
      users = create_list(:user, 10)
      users.each(&:confirm)
      users
    end

    let!(:pets) { create_list(:pet, 5, user: joined_users.first) }

    before do
      sign_in admin
      visit admins_root_path
    end

    scenario '管理者画面が表示されていること' do
      expect(page).to have_content 'ZeroWanApp 管理者画面'
    end

    scenario 'ユーザー登録数が正しく表示されていること' do
      expect(page).to have_content "ユーザー登録数\n#{joined_users.length}件"
    end

    scenario '里親募集数が正しく表示されていること' do
      expect(page).to have_content "里親募集数\n#{pets.length}件"
    end
  end
end
