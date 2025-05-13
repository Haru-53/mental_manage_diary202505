class DiaryEntry < ApplicationRecord
  validates :date, presence: true
  validates :good_things, presence: true
  validates :reflection, presence: true
  
  # JSONとして格納された複数の良かったことを取得するメソッド
  def good_things_array
    return [] if good_things.blank?
    
    begin
      JSON.parse(good_things)
    rescue JSON::ParserError
      # 既存のデータがJSON形式でない場合は単一の項目として配列に変換
      [good_things]
    end
  end
  
  # 良かったことを配列として設定するメソッド
  def good_things_array=(items)
    self.good_things = items.is_a?(Array) ? items.to_json : items.to_s
  end
  
  # 今日の日記かどうかを判定
  def today?
    date == Date.today
  end
  
  # 幸福度のグラフ用データを生成するクラスメソッド
  def self.happiness_chart_data(start_date = 30.days.ago.to_date, end_date = Date.today)
    where(date: start_date..end_date)
      .order(date: :asc)
      .pluck(:date, :happiness_level)
      .map { |date, level| { date: date.strftime("%Y-%m-%d"), level: level || 0 } }
  end
  
  # キーワードで日記を検索するクラスメソッド
  def self.search(keyword)
    where("good_things ILIKE ? OR reflection ILIKE ? OR notes ILIKE ?", 
          "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
  end
  
  # 月別サマリーを取得するクラスメソッド
  def self.monthly_summary(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    
    entries = where(date: start_date..end_date)
    
    {
      entry_count: entries.count,
      avg_happiness: entries.average(:happiness_level)&.round(1) || 0,
      entries: entries.order(date: :asc)
    }
  end
end