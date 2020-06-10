class User < ApplicationRecord

  has_many :boards
  has_many :records
  has_many :cards, through: :records

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :google_oauth2]

  # def self.create_from_provider_data(provider_data)
  #   where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
  #     user.email = provider_data.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #   end
  # end

  def self.create_from_provider_data(provider_data)
    users = where(provider: provider_data.provider, uid: provider_data.uid)

    if users.count == 0 && self.where(email: provider_data.info.email).count == 0
      return User.create(email: provider_data.info.email, password: Devise.friendly_token[0, 20], remote_photo_url: provider_data.info.image)
      
    end

    if users.count == 0 && self.where(email: provider_data.info.email).count != 0
      return self.where(email: provider_data.info.email).first
    end
    
    return users.first
  end
end
