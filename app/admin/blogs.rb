ActiveAdmin.register Blog do
  permit_params :user, :name, :description

  scope :all

  active_admin_paranoia

  index do
    selectable_column
    column :user
    column :name
    column :description do |model|
      if model.description.present?
        "#{model.description.truncate(23)}"
      else
        status_tag 'Empty'
      end
    end
    column :created_at
    column :updated_at
    column :deleted_at do |model|
      if model.deleted_at.present?
        "#{model.deleted_at}"
      else
        status_tag 'Empty'
      end
    end
    actions
  end

  form do |f|
    f.inputs 'Blog details' do
      f.input :user
      f.input :name
      f.input :description
    end
    f.actions
  end
end
