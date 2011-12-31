ActiveAdmin.register Reward do

  index do
    column :title
    column :text
    default_actions
  end
  show :title => :title do
    panel "Reward" do
      attributes_table_for reward do
        row("Title") {reward.title}
        row("Text") {reward.text}
      end
    end
    panel "Conditions" do
      table_for reward.reward_conditions do |t|
        t.column("Condition Type") { |reward_condition| reward_condition.condition_type.to_s }
        t.column("Condition Value") { |reward_condition| reward_condition.value}
      end
    end
  end

  form :partial => "form"

end
