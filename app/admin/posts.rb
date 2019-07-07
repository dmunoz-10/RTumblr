ActiveAdmin.register Post do
  permit_params :blog, :body, :private

  scope :all
  scope :privates
  scope :not_privates

  active_admin_paranoia

  index do
    selectable_column
    column :blog
    column :body do |model|
      if model.body.present?
        "#{model.body.truncate(23)}"
      else
        status_tag 'Empty'
      end
    end
    column :private
    column :visits
    column :likes
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
    f.inputs 'Post details' do
      f.input :blog, collection: Blog.all.map {|b| ["#{b.name} - #{b.user.username}"] }
      f.input :body
      f.input :private
    end
    f.actions
  end
end
