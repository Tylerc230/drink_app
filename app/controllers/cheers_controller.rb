class CheersController < ApplicationController
  def create
    fbid = params[:fbid]
    render :text => "Cheers sent to #{fbid}"
  end

end
