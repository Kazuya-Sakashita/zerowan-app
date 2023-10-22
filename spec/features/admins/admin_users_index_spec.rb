require 'rails_helper'

RSpec.feature 'admins/users/index', type: :feature do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user, &:confirm) }
  let!(:users) do
    users = create_list(:user, 21)
    users.each(&:confirm)
    users
  end

  before do
    sign_in admin
    visit admins_users_path
  end

  scenario 'ユーザー一覧ページを表示する' do
    expect(page).to have_content('ユーザー')
  end

  scenario 'ユーザー管理画面の表示内容の確認' do
    within 'tbody' do
      expect(page).to have_content(user.profile.name)
      expect(page).to have_content(user.created_at.strftime('%Y-%m-%d %H:%M:%S'))
      expect(page).to have_content(user.pets.count)
    end

    expect(page).to have_link('詳細', href: '#')
    expect(page).to have_link('削除', href: admins_user_path(user.id))
  end

  scenario 'ページネーションが表示される' do
    expect(page).to have_selector('.pagination')

    # ページネーションのページ数の検証
    pagination_text = page.text.split("\n").last
    expect(pagination_text).to include('1', '2', 'Next', 'Last')
  end
end
