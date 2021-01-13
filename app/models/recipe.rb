class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :ingredients
  has_many :comments 
  has many :commented_users, through: :comments, source: :user

  

end
