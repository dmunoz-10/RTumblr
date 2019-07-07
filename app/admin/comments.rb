ActiveAdmin.register Comment, as: 'PostComment' do
  permit_params :user, :post, :body

  scope :all

  active_admin_paranoia

  index do
    selectable_column
    column :user
    column :post
    column :body do |model|
      if model.body.present?
        "#{model.body.truncate(23)}"
      else
        status_tag 'Empty'
      end
    end
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
    f.inputs 'Comment details' do
      f.input :user
      f.input :post, collection: Post.all.map {|p| ["#{p.blog.user.username}'s post - #{p.body.truncate(33)}"]}
      f.input :body
    end
    f.actions
  end
end
