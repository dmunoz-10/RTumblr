class Blog < ApplicationRecord
  ### Soft delete ###
  acts_as_paranoid without_default_scope: true

  ### Scopes ###

  ### Validations ###
  # Validates presence of the following parameters
  validates_presence_of :name
  # Validates to have an association with a user
  validates_associated :user

  ### Associations ###
  # User Association
  belongs_to :user

  # Post Association
  has_many :posts, dependent: :destroy

  ### Methods ###
  # Rewrite the json when a blog is showed
  def as_json(*)
    super(except: %i[created_at updated_at deleted_at])
  end
end
