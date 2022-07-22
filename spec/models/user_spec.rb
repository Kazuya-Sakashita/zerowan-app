require 'rails_helper'


RSpec.describe User, type: :model do
  it "メール、パスワードが有効な状態であること" do
    user = build(:user)
    expect(user).to be_valid
    end
  
  it "メールアドレスがなければ無効であること" do
    user = FactoryBot.build(:user, email:nil)
    user.valid?
    expect(user.errors[:email]).to include("入力されていません。")
  end

  it "重複したメールアドレスなら無効な状態であること" do
  FactoryBot.create(:user, email:"test@example.com")
  user = FactoryBot.build(:user ,email:"test@example.com")
  user.valid?
  expect(user.errors[:email]).to include("重複しています。")
  end

  it "パスワードが６文字であれば有効なこと" do
  password6 = "123456"
  user = build(:user, password: "123456", password_confirmation: "123456")
  user.valid?
  expect(user).to be_valid
  end

  it "パスワードが６文字に満たない場合はバリデーションエラー発生すること" do
    user = build(:user, password: "12345", password_confirmation: "12345")
    user.valid?
    expect(user.errors[:password]).to include("文字数が足りていません。")
  end

end
