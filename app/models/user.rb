class User < ApplicationRecord
  ### Callbacks ###
  before_save  :lowercase_email
  after_create :create_personal_blog

  ### Encrypt password ###
  has_secure_password

  ### CarrierWave Settings ###
  mount_uploader :avatar, AvatarUploader

  ### Soft delete ###
  acts_as_paranoid without_default_scope: true

  ### Scopes ###
  # Gender scopes
  scope :males, -> { where(gender: 0) }
  scope :females, -> { where(gender: 1) }
  scope :transgenders, -> { where(gender: 2) }
  scope :transsexuals, -> { where(gender: 3) }
  scope :rather_not_to_say, -> { where(gender: 4) }
  scope :others, -> { where(gender: 5) }

  ### Data ###
  enum gender: %i[male female transgender transsexual rather_not_to_say other]

  ### Validations ###
  # Validates presence of the following parameters
  validates_presence_of :first_name, :last_name, :username, :gender, :email,
                        :password, :password_confirmation, :birth_date

  # First name validation
  MESSAGE_FIRST_NAME = 'The first name must be between 3 and 50 digits'
  validates :first_name, length: { in: 3..50, message: MESSAGE_FIRST_NAME }

  # Last name validation
  MESSAGE_LAST_NAME = 'The last name must be between 3 and 50 digits'
  validates :last_name, length: { in: 3..50, message: MESSAGE_LAST_NAME }

  # Validates age to be 18 or over
  validate :validate_age

  # Username validation
  USERNAME_REGEX = /(?![.])[a-zA-Z0-9._]+/.freeze
  MESSAGE_USERNAME = 'The username must be between 3 and 20 digits'
  validates :username, uniqueness: { case_sensitive: false }, on: :create,
                       format: { with: USERNAME_REGEX },
                       length: { in: 3..20, message: MESSAGE_USERNAME }

  # Email validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.freeze
  validates :email, uniqueness: { case_sensitive: false }, on: :create,
                    format: { with: EMAIL_REGEX }, length: { maximum: 50 }

  # Password validation
  PASSWORD_MESSAGE = 'The password must be between 6 and 20 digits'
  validates :password, :password_confirmation,
            length: { in: 6..20, message: PASSWORD_MESSAGE }

  # Phone number validation
  validates :phone_number, numericality: true, allow_nil: true,
                           uniqueness: true

  ### Associations ###
  # Blog Association
  has_many :blogs, dependent: :destroy

  # Follow Association
  has_many :passive_relationships, class_name: 'Follow',
                                   foreign_key: :follower_id,
                                   dependent: :destroy
  has_many :leaders, through: :passive_relationships, source: :leader
  has_many :active_relationships, class_name: 'Follow',
                                  foreign_key: :leader_id,
                                  dependent: :destroy
  has_many :followers, through: :active_relationships, source: :follower

  # Comment Association
  has_many :comments, dependent: :destroy

  # Like Post Association
  has_many :posts_likes
  has_many :liked_posts, through: :posts_likes, source: :post

  # Like Comment Association
  has_many :comments_likes
  has_many :liked_comments, through: :comments_likes, source: :comment

  ### Methods ###
  # Returns true if the current user is following the leader
  def following?(leader)
    leaders.include? leader
  end

  # Follows a leader
  def follow!(leader)
    leaders << leader if leader != self && !following?(leader)
  end

  # Unfollows a leader
  def unfollow!(leader)
    leaders.delete(leader) if leader != self && following?(leader)
  end

  # Returns all the leaders ID that the current user is following
  def timeline_user_ids(myself = true)
    myself ? leader_ids + [id] : leader_ids
  end

  # Returns true if the current user liked the post
  def liked_post?(post)
    liked_posts.include? post
  end

  # Likes the post
  def like_post!(post)
    liked_posts << post if !liked_post?(post)
  end

  # unlikes the post
  def unlike_post!(post)
    liked_posts.delete(post) if liked_post?(post)
  end

  # Returns true if the current user liked the comment
  def liked_comment?(comment)
    liked_comments.include? comment
  end

  # Likes the comment
  def like_comment!(comment)
    liked_comments << comment if !liked_comment?(comment)
  end

  # unlikes the comment
  def unlike_comment!(comment)
    liked_comments.delete(comment) if liked_comment?(comment)
  end

  # Rewrite the json when a user is showed
  def as_json(*)
    super(except: %i[password_digest created_at updated_at deleted_at])
  end

  private

  def validate_age
    if birth_date > 18.years.ago.to_date
      errors.add :birth_date, 'You should be over 18 years old.'
    end
  end

  def lowercase_email
    self.email = email.downcase
  end

  def create_personal_blog
    self.blogs.new(name: 'Personal')
  end
end
