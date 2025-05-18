class DiaryEntry < ApplicationRecord
  belongs_to :user

  validates :date, presence: true

  # 幸福度は1〜10の整数、空でもOK
  validates :happiness_level, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 10 
  }, allow_nil: true

  # フォームから送られる「よかったこと」の配列を受け取る（仮の属性）
  attr_accessor :good_things_array

  # 保存前に配列を文字列にまとめてgood_thingsに入れる
  before_validation :combine_good_things_array

  # 検索機能用
  scope :search, ->(keyword) {
    if keyword.present?
      where("reflection LIKE ? OR notes LIKE ? OR good_things LIKE ?", 
            "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    else
      all
    end
  }

  # 月ごとの集計
  def self.monthly_summary(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    entries = where(date: start_date..end_date)

    avg_happiness = entries.average(:happiness_level).to_f.round(1)

    good_things_count = entries.sum do |entry|
      entry.good_things.to_s.split(',').count { |gt| gt.strip.present? }
    end

    all_words = entries.flat_map do |entry|
      words = []
      words += entry.good_things.to_s.split(',')
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

  # グラフ用のデータを用意
  def self.happiness_chart_data(start_date, end_date)
    entries = where(date: start_date..end_date).order(:date)
    entries.map do |entry|
      {
        date: entry.date.strftime('%Y-%m-%d'),
        happiness: entry.happiness_level || 0
      }
    end
  end

  private

  # good_things_array（配列）をカンマ区切りの文字列に変換してgood_thingsに入れる
  def combine_good_things_array
    if good_things_array.is_a?(Array)
      self.good_things = good_things_array.reject(&:blank?).join(',')
    end
  end
end
