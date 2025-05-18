class PagesController < ApplicationController
  def contact
  end
  def announcements
    # お知らせの取得ロジックを追加
    # 例: @announcements = Announcement.order(created_at: :desc)
    # もしAnnouncementモデルがない場合は、作成するか、単純なビューだけを表示
  end
  def how_to_use
    # 特別なロジックが必要なければ空でOK
  end
end
