class User < ApplicationRecord
  # Deviseのモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :username, 
    presence: true, 
    uniqueness: true,
    length: {
      minimum: 2,
      maximum: 20
    },
    format: {
      with: /\A[a-zA-Z0-9_]+\z/,
      message: "は英数字とアンダーバーのみ使用できます"
    }

  validates :email,
    presence: true,
    uniqueness: true

    has_many :diary_entries
end
