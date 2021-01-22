class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :comments, :dependent => :destroy
  has_many :commented_recipes, through: :comments, source: :recipe
  has_many :friendships
  has_many :friends, through: :friendships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]
  
  has_many :user_recipes, :dependent => :destroy
  has_many :added_recipes, through: :user_recipes, source: :recipe 

  has_one_attached :avatar

  def self.new_with_session(params, session)
    super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name 
        user.image = auth.info.image 
      end
  end

end
