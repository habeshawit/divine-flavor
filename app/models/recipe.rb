class Recipe < ApplicationRecord
  belongs_to :user
  # belongs_to :category
  has_many :ingredients, dependent: :destroy
  # accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  has_many :comments 
  has_many :commented_users, through: :comments, source: :user

  validates :name, :ingredients, :steps, presence: true

  scope :most_commented, -> {left_joins(:comments).group('recipes.id').order('count(recipes.id) desc')}

  has_many_attached :images
  # def ingredient_attributes(attr)
  #   self.ingredients = Ingredient.find_or_create_by(attr) if !attr[:name].blank?
  # end
  

  def self.search(params)
      # @recipes = self.all.select { |recipe|  recipe.name.downcase.include?(params.downcase) || recipe.ingredients.downcase.include?(params.downcase)}          
      @recipes = where("LOWER(name) LIKE :term OR LOWER(description) LIKE :term", term: "%#{params.downcase}%") 
      if !@recipes.empty?
          return @recipes
      end
  end

end
