class DiaryEntry < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :happiness_level, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 10 
  }, allow_nil: true

  # good_things_arrayをシリアライズ（配列として保存・取得）
  serialize :good_things_array, coder: YAML

  # 検索機能用のスコープ
  scope :search, ->(keyword) {
    if keyword.present?
      where("reflection LIKE ? OR notes LIKE ? OR good_things_array LIKE ?", 
            "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    else
      all
    end
  }

  # 月別サマリー用メソッド
  def self.monthly_summary(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    entries = where(date: start_date..end_date)

    # 幸福度の平均を計算
    avg_happiness = entries.average(:happiness_level).to_f.round(1)

    # よかったことの回数をカウント
    good_things_count = entries.sum do |entry|
      (entry.good_things_array || []).count { |gt| gt.present? }
    end

    # 一番多かったキーワード
    all_words = entries.flat_map do |entry|
      words = []
      words += (entry.good_things_array || []).reject(&:blank?)
      words += entry.reflection.to_s.split(/[、。 ]/)
      words += entry.notes.to_s.split(/[、。 ]/)
      words.reject(&:blank?).map(&:strip)
    end

    word_counts = Hash.new(0)
    all_words.each { |word| word_counts[word] += 1 if word.length > 1 }
    most_common_word = word_counts.max_by { |_, count| count }&.first

    {
      entry_count: entries.count,
      avg_happiness: avg_happiness,
      good_things_count: good_things_count,
      most_common_word: most_common_word
    }
  end

  # グラフ表示用データメソッド
  def self.happiness_chart_data(start_date, end_date)
    entries = where(date: start_date..end_date).order(:date)

    entries.map do |entry|
      {
        date: entry.date.strftime('%Y-%m-%d'),
        happiness: entry.happiness_level || 0
      }
    end
  end
end
