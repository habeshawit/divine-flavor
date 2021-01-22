class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, :dependent => :destroy
  has_many :commented_users, through: :comments, source: :user
  has_many :user_recipes, :dependent => :destroy
  has_many :added_users, through: :user_recipes, source: :user

  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  validates :name, :ingredients, :steps, :category_name, presence: true

  scope :most_commented, -> {left_joins(:comments).group('recipes.id').order('count(recipes.id) desc')}

  has_many_attached :images

  def self.search(params)
      # @recipes = self.all.select { |recipe|  recipe.name.downcase.include?(params.downcase) || recipe.ingredients.downcase.include?(params.downcase)}          
      @recipes = where("LOWER(name) LIKE :term OR LOWER(description) LIKE :term", term: "%#{params.downcase}%") 
      if !@recipes.empty?
          return @recipes
      end
  end

  def category_name=(name)
    self.category = Category.find_or_create_by(name: name)
  end

  def category_name
     self.category ? self.category.name : nil
  end

end
