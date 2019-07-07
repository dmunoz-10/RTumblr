ActiveAdmin.register Follow do
  permit_params :leader, :follower

  scope :all

  active_admin_paranoia

  index do
    selectable_column
    column :leader
    column :follower
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
    f.inputs 'Follow details' do
      f.input :leader
      f.input :follower
    end
    f.actions
  end
end
