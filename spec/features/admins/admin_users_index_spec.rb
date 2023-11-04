require 'rails_helper'

RSpec.feature 'admins/users/index', type: :feature do
  let(:admin) { create(:admin) }
  let!(:users) { create_list(:user, 2, &:confirm) }

  before do
    sign_in admin
    visit admins_users_path
  end

  scenario 'ユーザー一覧ページを表示する' do
    expect(page).to have_content('ユーザー')
  end

  scenario 'ユーザー管理画面の表示内容の確認' do
    within 'tbody' do
      expect(page).to have_content(users.first.profile.name)
      expect(page).to have_content(users.first.created_at.strftime('%Y-%m-%d %H:%M:%S'))
      expect(page).to have_content(users.first.pets.count)
    end

    expect(page).to have_link('詳細', href: admins_user_path(users.first.id))
    expect(page).to have_link('削除', href: admins_user_path(users.first.id))
  end

  scenario 'ページネーションが表示される' do
    expect(page).to have_selector('.pagination')

    # ページネーションのページ数の検証
    pagination_text = page.find('.pagination').text
    expect(pagination_text).to include('1', '2', 'Next', 'Last')
  end
end
