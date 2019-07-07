class Follow < ApplicationRecord
  ### Soft delete ###
  acts_as_paranoid without_default_scope: true

  ### Validations ###
  # Validates to have an association with a leader and a follower
  validates_associated :leader, :follower

  ### Associations ###
  # Leader Association
  belongs_to :leader, foreign_key: 'leader_id', class_name: 'User'
  # Follower Association
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User'
end
