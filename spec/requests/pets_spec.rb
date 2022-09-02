require 'rails_helper'

RSpec.describe "Pets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/pets/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/pets/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/pets/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/pets/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
