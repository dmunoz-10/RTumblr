ActiveAdmin.register CommentsLike do
  permit_params :user, :comment

  scope :all

  active_admin_paranoia

  index do
    selectable_column
    column :user
    column :comment
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
    f.inputs "Comment's like details" do
      f.input :user
      f.input :comment, collection: Comment.all.map {|c| ["#{c.user.username}'s comment - #{c.id}"] }
    end
    f.actions
  end
end
