require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:owner) { create(:user) }
  let(:pet) { create(:pet, user: owner) }
  let(:room) { create(:room, user: user, owner: owner, pet: pet) }


  describe "バリデーション" do
    context "user_idとowner_idが同じ場合" do
    
        let(:room) { Room.new(user_id: user.id, owner_id: user.id, pet_id: pet.id) }
      

      it "無効である" do
        expect(room).not_to be_valid
      end

      it '無効である場合、バリデーションエラー発生すること' do
        room.valid?
        expect(room.errors[:owner_id]).to include("owner_idとuser_idは同じにできません")
      end
    end

    context "user_idとowner_idが異なる場合" do
      it "有効である" do
        room = Room.new(user_id: user.id, owner_id: owner.id, pet_id: pet.id)
        expect(room).to be_valid
      end
    end
  end
end
