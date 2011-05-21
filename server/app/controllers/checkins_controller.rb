class CheckinsController < ApplicationController
  def create
  	user_id = params[:user_id]
	item_id = params[:item_id]
  	count = params[:count]
	puts params
	checking = Checkin.new(:user_id => user_id, :item_id => item_id, :count => count)
	checking.save
  end

end
