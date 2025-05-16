class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  # バリデーション
  validates :username, 
    presence: true, 
    uniqueness: true, 
    length: {
      minimum: 2,    # 最小2文字
      maximum: 20    # 最大20文字
    }, 
    format: {
      with: /\A[a-zA-Z0-9_]+\z/,  # 英数字とアンダーバーのみ許可
      message: "は英数字とアンダーバーのみ使用できます"
    }
end
