class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :liked_posts, through: :likes, source: :post
  has_many :bookmarked_posts, through: :bookmarks, source: :post

  # Subscription for premium membership
  has_one :subscription, dependent: :destroy

  # Tips: received and sent
  has_many :received_tips, class_name: "Tip", foreign_key: "recipient_id", dependent: :destroy
  has_many :sent_tips, class_name: "Tip", foreign_key: "sender_id", dependent: :destroy

  # Profile fields
  has_one_attached :uploaded_avatar

  devise :validatable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  # Premium membership helpers
  def premium?
    subscription&.premium?
  end

  def current_plan
    subscription&.plan || "free"
  end

  # Total tips received (in cents)
  def total_tips_received
    received_tips.succeeded.sum(:amount)
  end

  # Display name with premium badge
  def display_name
    if premium? && subscription&.features[:badge]
      "#{full_name} #{subscription.features[:badge]}"
    else
      full_name
    end
  end
end
