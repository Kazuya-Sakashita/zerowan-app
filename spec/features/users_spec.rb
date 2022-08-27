require 'rails_helper'

RSpec.feature '会員登録', type: :feature do
  before do
    #会員登録画面に行く
    visit new_user_registration_path
    ActionMailer::Base.deliveries.clear
  end

  describe '登録画面' do
    context '正常系' do
      scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
        expect(page).to have_content 'パスワード（確認用）'
        expect(page).to have_content 'お名前'
        expect(page).to have_content 'ご住所'
        expect(page).to have_content 'お電話番号'
        expect(page).to have_content '生年月日'
        expect(page).to have_content '飼主経験'

        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
        expect(page).to have_field 'user[profile_attributes][name]'
        expect(page).to have_field 'user[profile_attributes][address]'
        expect(page).to have_field 'user[profile_attributes][phone_number]'
        expect(page).to have_field 'user[profile_attributes][birthday]'
        expect(page).to have_field 'user[profile_attributes][breeding_experience]'
        expect(page).to have_button '登録内容確認'
      end

      scenario '正しく値を入力した場合、登録確認画面に遷移すること' do
        fill_in 'メールアドレス', with: 'kz0508+88@gmail.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        fill_in 'お名前', with: 'KAZUYA'
        fill_in 'ご住所', with: '大阪市'
        fill_in 'お電話番号', with: '00000000000'
        fill_in '生年月日', with: '2022-06-26'
        fill_in '飼主経験', with: '猫1年'
        click_button '登録内容確認'
        expect(page).to have_current_path('/users/sign_up/confirm')
      end
    end
    context '異常系' do
      scenario '値が全て入力されていなかった場合、バリデーションエラーの内容が表示されること' do
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード', with: nil
        fill_in 'パスワード（確認用）', with: nil
        fill_in 'お名前', with: nil
        fill_in 'ご住所', with: nil
        fill_in 'お電話番号', with: nil
        fill_in '生年月日', with: nil
        fill_in '飼主経験', with: nil
        click_button '登録内容確認'
        expect(page).to have_selector 'h2', text: '8 件のエラーが発生したため ユーザー は保存されませんでした。'
        expect(page).to have_selector 'li', text: 'メールアドレス 入力されていません。'
        expect(page).to have_selector 'li', text: 'パスワード 入力されていません。'
        expect(page).to have_selector 'li', text: 'ご住所 入力されていません。'
        expect(page).to have_selector 'li', text: 'お電話番号 入力されていません。'
        expect(page).to have_selector 'li', text: 'お電話番号 が無効です。'
        expect(page).to have_selector 'li', text: '生年月日 入力されていません。'
        expect(page).to have_selector 'li', text: '飼主経験 入力されていません。'
      end
    end
  end

  describe '確認画面' do
    before do
      fill_in 'メールアドレス', with: 'kz0508+88@gmail.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      fill_in 'お名前', with: 'KAZUYA'
      fill_in 'ご住所', with: '大阪市'
      fill_in 'お電話番号', with: '00000000000'
      fill_in '生年月日', with: '2022-06-26'
      fill_in '飼主経験', with: '猫1年'
      click_button '登録内容確認'
    end
    scenario '表示される内容が正しいこと' do
      expect(page).to have_current_path('/users/sign_up/confirm')
      expect(page).to have_content 'kz0508+88@gmail.com'
      expect(page).to have_content 'password'
      expect(page).to have_content 'KAZUYA'
      expect(page).to have_content '大阪市'
      expect(page).to have_content '00000000000'
      expect(page).to have_content '2022年06月26日'
      expect(page).to have_content '猫1年'
    end

    scenario '「登録」ボタンを押下で Home 画面に遷移すること' do
      click_button '登録'
      expect(page).to have_current_path('/')
    end

    scenario 'flash メッセージが正しく表示されていること' do
      click_button '登録'
      expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
    end

    scenario '「登録」ボタンを押下でメール送信処理が行われること' do
      expect do
        click_button '登録'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    scenario '「修正」ボタンを押下で登録画面に戻れること' do
      click_button '修正'
      expect(page).to have_current_path('/users')
    end
  end

  describe '本人確認' do
    before do
      fill_in 'メールアドレス', with: 'kz0508+88@gmail.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      fill_in 'お名前', with: 'KAZUYA'
      fill_in 'ご住所', with: '大阪市'
      fill_in 'お電話番号', with: '00000000000'
      fill_in '生年月日', with: '2022-06-26'
      fill_in '飼主経験', with: '猫1年'
      click_button '登録内容確認'
    end
    context '正常系' do
      scenario 'メールに含まれる確認トークンで本人確認 URL にアクセスするとログイン画面に遷移すること' do
        click_button '登録'
        user = User.last
        visit user_confirmation_path(confirmation_token: user.confirmation_token)
        expect(page).to have_current_path('/users/sign_in')
      end
    end
    context '異常系' do
      scenario 'params にユーザーの confirmation_token が含まれていない場合、エラー画面が描画されること' do
        click_button '登録'
        visit user_confirmation_path(confirmation_token: nil)
        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした。'
      end
    end
  end

  describe 'プロフィール編集画面' do
    before do
      @user = create(:user, email:'test123456789@test.com',password:'password', password_confirmation: 'password')
      @user.confirm

    end
    describe 'プロフィール' do
      context '正常系' do
        scenario '表示される内容が正しいこと（フォームの内容やボタン、リンク等が正しく表示されていること）' do
          sign_in @user
          visit(edit_user_path(@user))

          binding.pry
          expect(page).to have_selector '#user_profile_attributes_name', text: 'test123456789@test.com'
          # expect(page).to have_current_path('/users/3903/edit')
          # expect(page).to have_content 'test123456789@test.com'
          # expect(page).to have_content 'password'
          # expect(page).to have_content 'KAZUYA'
          # expect(page).to have_content '大阪市'
          # expect(page).to have_content '00000000000'
          # expect(page).to have_content '2022年06月26日'
          # expect(page).to have_content '猫1年'
          # expect(page).to have_button 'プロフィール内容変更'
          expect(page).to have_button 'プロフィール内容変更'
          expect(page).to have_button 'アカウント情報更新'

        end
        'プロフィール正しく値を入力した場合、ユーザーのマイページ画面に遷移すること'
      end

      context '異常系' do
        'プロフィール正しく値を入力なかった場合、バリデーションエラーの内容が表示されること'
      end
    end
  end
  describe 'アカウント情報' do
    context '正常系' do
      'アカウント情報を正しく入力した場合、Home 画面に遷移すること'
      'アカウント情報を正しく入力した場合、flash メッセージが正しく表示されること'
    end

    context '異常系' do
      'アカウント情報を正しく入力しなかった場合、flash メッセージが正しく表示されること'
      '現在のパスワードを入力し、email を入力しなかった場合、バリデーションエラーの内容が表示されること'
      '現在のパスワードを入力し、パスワードと確認用パスワードが異なっていた場合、バリデーションエラーの内容が表示されること'
    end
  end

end
