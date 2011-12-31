ActiveAdmin.register RewardCondition do
  menu false
  member_action :delete do
    reward_condition = RewardCondition.find(params[:id])
    reward_condition.delete
    redirect_to :action => :show
  end

end
