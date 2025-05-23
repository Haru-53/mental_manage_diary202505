class User < ApplicationRecord
<<<<<<< HEAD
  # Deviseのモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
=======
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :omniauthable, omniauth_providers: %i[google twitter line]
>>>>>>> login_logout_registration

  # バリデーション
  validates :username, 
    presence: true, 
<<<<<<< HEAD
    uniqueness: true,
    length: {
      minimum: 2,
      maximum: 20
    },
=======
    uniqueness: true, 
    length: { minimum: 2, maximum: 20 },
>>>>>>> login_logout_registration
    format: {
      with: /\A[a-zA-Z0-9_]+\z/,
      message: "は英数字とアンダーバーのみ使用できます"
    }

<<<<<<< HEAD
  validates :email,
    presence: true,
    uniqueness: true

    has_many :diary_entries
end
=======
  # SNSログイン時の処理
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
      user.image = auth.info.image
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    end
  end
end
>>>>>>> login_logout_registration
