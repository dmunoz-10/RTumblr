class Comment < ApplicationRecord
  ### Soft Delete ###
  acts_as_paranoid without_default_scope: true

  ### kaminari config ###
  paginates_per 20

  ### Scopes ###

  ### Validations ###
  # Validates presence of the following parameters
  validates_presence_of :body
  # Validates to have an association with a post and a user
  # validates_associated :post, :user

  ### Associations ###
  # Post Association
  belongs_to :post

  # User Association
  belongs_to :user

  # Like Association
  has_many :comments_likes
  has_many :liking_users, through: :comments_likes, source: :user

  ### Methods ###
  # Update likes count
  def update_likes_count
    self.update(likes: self.liking_users.count)
  end

  # Rewrite the json when a comment is showed
  def as_json(*)
    super(except: %i[updated_at deleted_at])
  end
end
