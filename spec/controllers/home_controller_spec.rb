require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'home画面' do
    it 'home画面が描画されていること' do
      get :index
      expect(response).to render_template '/'
    end
  end
end