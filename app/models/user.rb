class User < ApplicationRecord

  has_many :boards
  has_many :records
  has_many :cards, through: :records

  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]
  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize: "40x40!").processed 
    else
      "/default_profile.jpg"
    end
  end

  private
  def add_default_avatar
    unless avatar.attached?
    avatar.attach(
      io: File.open(
        Rails.root.join(
          'app', 'assets', 'images', 'default_avatar.jpg'
        )
      ), 
      filename: 'default_profile.jpg',
      content_type: 'image/jpg'
    )
  end
    end
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
      return User.create(email: provider_data.info.email, password: Devise.friendly_token[0, 20])
    end

    if users.count == 0 && self.where(email: provider_data.info.email).count != 0
      return self.where(email: provider_data.info.email).first
    end
    
    return users.first
  end
end
