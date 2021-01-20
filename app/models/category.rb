class Category < ApplicationRecord
    has_many :recipes, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: true
end
