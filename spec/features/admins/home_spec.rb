require 'rails_helper'

RSpec.feature 'Admins::Homes', type: :feature do
  describe 'GET /index' do
    let(:admin) { create(:admin) }

    before do
      sign_in admin
      visit admins_home_index_path
    end

    scenario '管理者画面が表示されていること' do
      expect(page).to have_current_path(admins_home_index_path)
      expect(page).to have_content 'ZeroWanApp 管理者画面'
    end
  end
end
