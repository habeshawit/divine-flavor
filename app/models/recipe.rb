class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments 
  has many :commented_users, through: :comments, source: :users
end
