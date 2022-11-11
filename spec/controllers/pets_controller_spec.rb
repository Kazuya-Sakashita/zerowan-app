require 'rails_helper'

RSpec.describe PetsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '里親募集登録' do
    let(:user) do
      create(:user, email: 'test123456789@test.com', password: 'password12345', password_confirmation: 'password12345', &:confirm)
    end
    let(:params) do
      {
        pet_form: {
          photos: ['dog2.jpeg']
        },
        pet: {
          category: :dog,
          petname: 'riku',
          age: 12,
          gender: :male,
          classification: :Chihuahua,
          introduction: 'おとなしく、賢い',
          castration: :neutered,
          vaccination: :vaccinated,
          recruitment_status: :recruiting,
          user_id: user.id
        }
      }
    end

    before do
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

    context 'pet/update' do
      before do
        @pet = create(:pet, user_id: user.reload.id)
        @pet_params = attributes_for(:pet,
                                    category: :dog,
                                    petname: 'SORA',
                                    age: 5,
                                    gender: :male,
                                    classification: :Chihuahua,
                                    introduction: 'やんちゃ、内弁慶',
                                    castration: :neutered,
                                    vaccination: :vaccinated,
                                    recruitment_status: :recruiting,
                                    user_id: user.id
        )
        put :update, params: { id: @pet.id, pet: @pet_params }
      end
      context '正常系' do
        it '修正時時、各パラメータに正しく値が設定された場合、SHOW画面が描画されること' do

          expect(response).to redirect_to pet_path(@pet.id)
        end

        it '修正時、各パラメータに正しく値が設定された場合、Petが正しく修正されていること' do
          expect(@pet.reload.category.to_sym).to eq @pet_params[:category]
          expect(@pet.reload.petname).to eq @pet_params[:petname]
          expect(@pet.reload.age).to eq @pet_params[:age]
          expect(@pet.reload.gender.to_sym).to eq @pet_params[:gender]
          expect(@pet.reload.classification.to_sym).to eq @pet_params[:classification]
          expect(@pet.reload.introduction).to eq @pet_params[:introduction]
          expect(@pet.reload.castration.to_sym).to eq @pet_params[:castration]
          expect(@pet.reload.vaccination.to_sym).to eq  @pet_params[:vaccination]
          expect(@pet.reload.recruitment_status.to_sym).to eq  @pet_params[:recruitment_status]
        end

        it '各パラメータに正しく値が設定された場合、flash画面が正しく表示されていること' do
          expect(flash[:notice]).to eq '登録完了しました。'
        end
      end

      context '異常系' do
        before do
          pet_params = attributes_for(:pet,
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
          )
          put :update, params: { id: @pet.id, pet: pet_params }
        end
        it '修正時、各パラメータに正しく値が設定されなかった場合、登録画面が描画されること' do
          expect(response).to redirect_to edit_pet_path(@pet)
        end

          it '各パラメータに正しく値が設定されていなかあった場合、flash画面が正しく表示されていること' do
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

  end
end