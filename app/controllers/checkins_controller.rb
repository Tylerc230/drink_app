class CheckinsController < ApplicationController
  def create
  	user_id = params[:user_id]
	item_id = params[:item_id]
  	count = params[:count]
	engine = RewardEngine.new
#TODO add a timestamp with users local time, or their timezone
	checking = Checkin.new(:user_id => user_id, :item_id => item_id, :count => count)
	checking.save
  end

end
