class CommentsLike < ApplicationRecord
  ### Soft deleted ###
  acts_as_paranoid without_default_scope: true

  ### Validations ###
  # Validates to have an association with a user and a comment
  validates_associated :user, :comment

  ### Associations ###
  # User Association
  belongs_to :user
  # Comment Association
  belongs_to :comment
end
