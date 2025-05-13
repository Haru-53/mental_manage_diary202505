class HappinessItem < ApplicationRecord
  validates :name, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  def self.weighted_score
    total_weight = all.sum(&:weight)
    return 0 if total_weight == 0
  
    satisfied_weight = where(satisfied: true).sum(&:weight)
    ((satisfied_weight.to_f / total_weight) * 100).round
  end
end
