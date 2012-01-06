ActiveAdmin.register Drink do
  index do
    column :id
    column :name
    default_actions
  end

  form do |f|
    f.inputs  do
      f.input :name
      f.input :tags, :as => :check_boxes#, :multiple => true#, :collection => @tags
    end
    f.buttons
  end

  controller do
    def update
      resource.tag_ids = params['drink']['tag_ids']
      super()
    end
  end


end
