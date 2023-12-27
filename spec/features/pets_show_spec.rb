require 'rails_helper'

RSpec.feature '里親募集', type: :feature do
  let!(:own) do
    create(:user, email: 'test123456789@test.com', password: 'password', password_confirmation: 'password', &:confirm)
  end

  let!(:pet) do
    create(:pet,
           category: :dog,
           petname: 'taro20221101',
           age: 12,
           gender: :male,
           classification: :Chihuahua,
           introduction: 'おとなしく、賢い',
           castration: :neutered,
           vaccination: :vaccinated,
           recruitment_status: 0,
           user: own)
  end

  before do
    sign_in own
    visit root_path
    click_link 'ペット詳細情報を確認'
  end

  context 'ペット詳細情報画面表示' do
    scenario 'ペット一覧から遷移ができること' do
      expect(page).to have_current_path pet_path(pet), ignore_query: true
    end

    scenario 'ペットの詳細が表示されていること' do
      expect(page).to have_content 'taro20221101'
      expect(page).to have_content 'オス'
      expect(page).to have_content '12才'
      expect(page).to have_content 'チワワ'
      expect(page).to have_content 'おとなしく'
      expect(page).to have_content '接種済'
      expect(page).to have_content '去勢済'
    end
  end

  context '編集ページへと遷移するボタン表示' do
    let!(:other_own) do
      create(:user, email: 'test20221104@test.com', password: 'password', password_confirmation: 'password',
             &:confirm)
    end

    let!(:other_pet) do
      create(:pet,
             category: :dog,
             petname: 'test20221104',
             age: 12,
             gender: :male,
             classification: :Chihuahua,
             introduction: 'おとなしく、賢い',
             castration: :neutered,
             vaccination: :vaccinated,
             recruitment_status: 0,
             user: other_own)
    end

    describe 'ステータス表示' do
      scenario '自身の投稿の場合、表示していること' do
        expect(page).to have_link 'ペット情報を編集する'
      end

      scenario '他者投稿の表示していないこと' do
        visit pet_path(other_pet)
        expect(page).not_to have_link 'ペット情報を編集する'
        expect(page).to have_content 'test20221104'
      end
    end
  end

  describe 'お気に入り機能' do
    before do
      customer = create(:user, email: 'test121212@test.com', password: 'password', password_confirmation: 'password',
                        &:confirm)
      sign_in customer
      visit pet_path(pet)
    end

    scenario 'お気に入り登録できること', js: true do
      click_link '★ 気になるリストに追加'
      expect(page).to have_content '☆ 気になるリストから削除'
    end

    scenario 'お気に入り削除できること', js: true do
      click_link '★ 気になるリストに追加'
      expect(page).to have_content '☆ 気になるリストから削除'
      click_link '☆ 気になるリストから削除'
      expect(page).to have_content '★ 気になるリストに追加'
    end

    scenario 'メッセージを送るボタンが表示されていること' do
      expect(page).to have_link 'ペット飼い主にメッセージを送る'
    end
  end

  describe 'ステータス表示' do
    let!(:user) { create(:user, &:confirm) }

    context '投稿者のオーナーがログインしている場合' do
      before do
        sign_in own
        visit pet_path(pet.id)
      end

      scenario '募集中の表示（アクティブ）がされていること' do
        expect(page).to have_selector('input.active[value="募集中"]')
      end

      scenario '交渉中選択で交渉中が表示（アクティブ）がされていること', js: true do
        click_button '交渉中'
        expect(page).to have_selector('input.active[value="交渉中"]')
      end

      scenario '家族決定選択で家族決定が表示（アクティブ）がされていること', js: true do
        click_button '家族決定'
        expect(page).to have_selector('input.active[value="家族決定"]')
      end

      scenario '募集中選択で募集中が表示（アクティブ）がされていること', js: true do
        click_button '交渉中'
        expect(page).to have_selector('input.active[value="交渉中"]')

        click_button '募集中'
        expect(page).to have_selector('input.active[value="募集中"]')
      end
    end

    context 'ユーザーがログインしている場合' do
      before do
        sign_in user
        visit pet_path(pet.id)
      end

      scenario 'ステータスの表示がないこと' do
        expect(page).to have_no_selector('input[value="募集中"]')
        expect(page).to have_no_selector('input[value="家族決定"]')
        expect(page).to have_no_selector('input[value="交渉中"]')
      end
    end
  end

  describe 'メッセージ送信ボタンの表示' do
    let(:owner) { create(:user, &:confirm) }
    let(:user) { create(:user, &:confirm) }
    let!(:pet) { create(:pet, user: owner) }

    context 'ログインがオーナーの場合' do
      before do
        sign_in owner
        visit pet_path(pet.id)
      end

      scenario 'ペット飼い主にメッセージを送るボタンが表示されていないこと' do
        expect(page).not_to have_content('ペット飼い主にメッセージを送る')
        expect(page).not_to have_content('*メッセージ機能を利用するには会員登録が必要です')
      end
    end

    context 'ログインがユーザーの場合' do
      before do
        sign_in user
        visit pet_path(pet.id)
      end

      scenario 'ペット飼い主にメッセージを送るボタンが表示されていること' do
        expect(page).to have_content('ペット飼い主にメッセージを送る')
        expect(page).not_to have_content('*メッセージ機能を利用するには会員登録が必要です')
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
        visit pet_path(pet.id)
      end

      scenario 'メッセージ機能を利用するには会員登録が必要ですが表示されていること' do
        expect(page).not_to have_content('ペット飼い主にメッセージを送る')
        expect(page).to have_content('*メッセージ機能を利用するには会員登録が必要です')
      end
    end
  end
end
