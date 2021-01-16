class Recipe < ApplicationRecord
  belongs_to :user
  # belongs_to :category
  # has_many :ingredients
  has_many :comments 
  
  has_many :commented_users, through: :comments, source: :user

  validates :name, :ingredients, :instructions, presence: true

  scope :most_commented, -> {left_joins(:comments).group('recipes.id').order('count(recipes.id) desc')}

  # def ingredient_attributes(attr)
  #   self.ingredients = Ingredient.find_or_create_by(attr) if !attr[:name].blank?
  # end

  def self.search(params)
      # @recipes = self.all.select { |recipe|  recipe.name.downcase.include?(params.downcase) || recipe.ingredients.downcase.include?(params.downcase)}         # @recipes = current_user.recipes.where('lower(name) = ?' LIKE params[:recipe].downcase)
      @recipes = where("LOWER(name) LIKE :term OR LOWER(ingredients) LIKE :term", term: "%#{params.downcase}%")
      if !@recipes.empty?
          return @recipes
      end
  end

end
