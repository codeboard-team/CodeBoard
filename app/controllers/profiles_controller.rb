class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @solved_card = @user.records.where(solved: true)
  end
end
