ActiveAdmin.register PostsLike do
  permit_params :user, :post

  scope :all

  active_admin_paranoia

  index do
    selectable_column
    column :user
    column :post
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
    f.inputs "Post's like details" do
      f.input :user
      f.input :post, collection: Post.all.map {|p| ["#{p.blog.user.username}'s post - body: #{p.body.truncate(33)} - id: #{p.id}"]}
    end
    f.actions
  end
end
