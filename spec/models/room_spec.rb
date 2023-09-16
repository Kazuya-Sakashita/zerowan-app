require 'rails_helper'

RSpec.describe Room, type: :model do
  # インスタンスを作成
  let(:user) { create(:user) }
  let(:owner) { create(:user) }
  let(:pet) { create(:pet, user: owner) }
  let(:room) { create(:room, user: user, owner: owner, pet: pet) }


  # latest_messageメソッドのテスト
  describe "#latest_messageメソッド" do
    let!(:older_message) { create(:message, room: room, user: user, created_at: 1.day.ago) }
    let!(:newer_message) { create(:message, room: room, user: user) }

    it "最新のメッセージを返すこと" do
      expect(room.latest_message).to eq(newer_message)
    end
  end

  # petname_extractionクラスメソッドのテスト
  describe ".petname_extractionクラスメソッド" do
    it "ルームに関連するペットを返すこと" do
      expect(Room.petname_extraction(room.id)).to eq(pet)
    end
  end
end
