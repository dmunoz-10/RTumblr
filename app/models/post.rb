class Post < ApplicationRecord
  ### Soft delete ###
  acts_as_paranoid without_default_scope: true

  ### kaminari config ###
  paginates_per 10

  ### Scopes ###
  # Private Posts
  scope :privates, -> { where(private: true) }
  # Not Private Posts
  scope :not_privates, -> { where(private: false) }

  ### Validations ###
  # Validates to accept only true or false in private parameter
  validates :private, inclusion: { in: [true, false] }
  # Validates to have an association with a blog
  # validates_associated :blog

  ### Associations ###
  # Blog Association
  belongs_to :blog

  # Comment Association
  has_many :comments, dependent: :destroy

  # Like Association
  has_many :posts_likes
  has_many :liking_users, through: :posts_likes, source: :user

  ### Methods ###
  # Update visits count
  def update_visits_count
    self.update(visits: self.visits + 1)
  end

  # Update likes count
  def update_likes_count
    self.update(likes: self.liking_users.count)
  end

  # Rewrite the json when a post is showed
  def as_json(*)
    super(except: %i[deleted_at])
  end
end
