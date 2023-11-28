require 'rails_helper'

RSpec.feature 'ページネーションの表示', type: :feature do
  let(:user) { create(:user, &:confirm) }
  let!(:owner) { create(:user, &:confirm) }
  let!(:pet) { create(:pet, user: owner) }

  before do
    sign_in user
    visit root_path
  end

  describe '1件の場合' do
    context '１ページ目' do
      scenario '1件のペットが表示されていること' do
        expect(page).to have_content pet.petname
      end

      scenario 'ページネーションコントロールが存在しないこと' do
        expect(page).not_to have_selector '.pagination'
      end
    end
  end

  describe '2件以上ある場合' do
    let!(:another_pet) { create(:pet, user: owner) }

    before do
      visit root_path
    end

    context '１ページ目' do
      scenario 'ペットが表示されていること' do
        expect(page).to have_content pet.petname
      end

      scenario '他のペットは表示されていないこと' do
        expect(page).not_to have_content another_pet.petname
      end

      scenario 'ページネーションコントロールが存在すること' do
        expect(page).to have_selector '.pagination'
      end
    end

    context '2ページ目' do
      before do
        click_link '2'
      end

      scenario '2ページ目が表示されていること' do
        expect(page).to have_current_path(/page=2/)
      end

      scenario '他のペットが表示されていること' do
        expect(page).to have_content another_pet.petname
      end
    end
  end
end
