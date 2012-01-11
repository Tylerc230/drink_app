ActiveAdmin.register Drink do
  index do
    column :id
    column :name
    default_actions
  end

  #form do |f|
  #  f.inputs  do
  #    f.input :name
  #    f.input :tags, :as => :check_boxes
  #  end
  #  f.buttons
  #end
  form :partial => 'edit'

  controller do
    def new_tag
      new_tag = params[:new_tag]
      drink = Drink.find(params[:id])
      drink.tag_list << new_tag
      drink.save
      redirect_to edit_admin_drink_path(drink)
    end
    def update
      resource.tag_ids = params['drink']['tag_ids']
      super()
    end
  end


end
