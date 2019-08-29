class PostsLike < ApplicationRecord
  ### soft delete ###
  acts_as_paranoid without_default_scope: true

  ### Validations ###
  # Validates to have an association with a user and a post
  # validates_associated :user, :post

  ### Associations ###
  # User Association
  belongs_to :user
  # Post Association
  belongs_to :post
end
