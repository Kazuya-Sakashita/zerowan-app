# app/controllers/pets/pickups_controller.rb

module Admins
  module Pets
    class PickupsController < ApplicationController
      before_action :set_pet

      def create
        if @pet.pickup
          redirect_to admins_pet_path(@pet), alert: 'すでにピックアップされています。'
        else
          @pet.create_pickup
          redirect_to admins_pet_path(@pet), notice: 'ピックアップに追加されました。'
        end
      end

      def destroy
        if @pet.pickup
          pickup = @pet.pickup
          pickup.destroy
          redirect_to root_path, notice: 'ピックアップから削除されました。'
        else
          redirect_to admins_pet_path(@pet), alert: 'このペットはピックアップされていません。'
        end
      end

      private

      def set_pet
        @pet = Pet.find(params[:pet_id])
      end
    end
  end
end
