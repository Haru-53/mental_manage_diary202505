class User < ApplicationRecord
  # Deviseのモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter line]

  # アソシエーション
  has_many :diary_entries, dependent: :destroy

  # バリデーション
  validates :username, 
    presence: true, 
    uniqueness: true,
    length: { minimum: 2, maximum: 20 },
    format: {
      with: /\A[a-zA-Z0-9_]+\z/,
      message: "は英数字とアンダーバーのみ使用できます"
    }

  validates :email,
    presence: true,
    uniqueness: true

  # SNSログイン時の処理
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
      user.image = auth.info.image if user.respond_to?(:image=)
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    end
  end
end

