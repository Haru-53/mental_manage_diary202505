class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable # 必要に応じてモジュールを追加/削除
  # バリデーション
  validates :username, presence: true, uniqueness: true
end
