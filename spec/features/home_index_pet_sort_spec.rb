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

  scenario '新着順に表示されること' do
    # TODO match %r{#{pet.petname}.*#{other_pet.petname}}この書き方でどうにかしたかったのですが、できませんでした。
    # expect(have_selector '.petname', visible: false).to match %r{#{pet.petname}.*#{other_pet.petname}}

    expect(page.all('.petname')[0].text).to have_content pet.petname
    expect(page.all('.petname')[1].text).to have_content other_pet.petname
  end

  scenario '登録順に表示されること' do
    select '新着順', from: 'q_sorts'
    click_button '検索する'
    expect(page.all('.petname')[0].text).to have_content other_pet.petname
    expect(page.all('.petname')[1].text).to have_content pet.petname
  end
end