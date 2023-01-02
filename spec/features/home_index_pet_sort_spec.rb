require 'rails_helper'

RSpec.feature 'ソート機能', type: :feature do
  let!(:user) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  let!(:pet) do
    create(:pet)
  end

  let!(:other_pet) do
    create(:pet)
  end

  before do
    visit root_path
  end

  scenario 'セレクトボックスが表示されていること' do
    expect(page).to have_select('q[sorts]', options: %w!新着順 登録順!)
  end
end