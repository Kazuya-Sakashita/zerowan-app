require 'rails_helper'

RSpec.describe PetsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '里親募集登録' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end

    let(:area) do
      create(:area, place_name: '大阪')
    end

    let(:params) do
      {
        pet_form: {
          photos: ['dog2.jpeg']
        },
        pet: {
          category: :dog,
          petname: :riku,
          age: 12,
          gender: :male,
          classification: :Chihuahua,
          introduction: 'おとなしく、賢い',
          castration: :neutered,
          vaccination: :vaccinated,
          recruitment_status: 0,
          user_id: user.id
        },
        area_form: {
          areas: [ area.id ]
        }
      }
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
    context 'pet/new' do
      context '正常系' do
        it '登録画面が描画されること' do
          get :new
          expect(response).to render_template 'pets/new'
        end
      end
    end

    context 'pet/create' do
      context '正常系' do
        it '登録時、各パラメータに正しく値が設定された場合、SHOW画面が描画されること' do
          post :create, params: params
          expect(response).to redirect_to pet_path(Pet.last.id)
        end

        it '登録時、各パラメータに正しく値が設定された場合、Petが正しく作成されていること' do
          expect { post :create, params: params }.to change(Pet, :count).by(1)
        end

        it '各パラメータに正しく値が設定された場合、flash画面が正しく表示されていること' do
          post :create, params: params
          expect(flash[:notice]).to eq '登録完了しました。'
        end
      end
      context '異常系' do
        let!(:params) do
          {
            pet_form: {
              photos: []
            },
            pet: {
              category: nil,
              petname: nil,
              age: nil,
              gender: nil,
              classification: nil,
              introduction: nil,
              castration: nil,
              vaccination: nil,
              recruitment_status: nil,
              user_id: nil
            },
            area_form: {
              areas: [ nil ]
            }
          }
        end

        it '登録時、各パラメータに正しく値が設定されなかった場合、登録画面が描画されること' do
          post :create, params: params
          expect(response).to redirect_to new_pet_path
        end

        it '各パラメータに正しく値が設定されていなかあった場合、flash画面が正しく表示されていること' do
          post :create, params: params
          expect(flash[:alert]).to eq [
                                        "ペットのお名前を入力してください",
                                        "カテゴリを入力してください",
                                        "ペットのご紹介を入力してください",
                                        "性別を入力してください",
                                        "年齢を入力してください",
                                        "種別を入力してください",
                                        "去勢有無を入力してください",
                                        "ワクチン接種有無を入力してください"
                                      ]
        end
      end
    end

    context 'pet/show' do
      context '正常系' do
        it 'SHOW画面が描画されること' do
          post :create, params: params
          get :show, params: { id: Pet.last.id }
          expect(response).to render_template 'pets/show'
        end
      end
    end
  end
end