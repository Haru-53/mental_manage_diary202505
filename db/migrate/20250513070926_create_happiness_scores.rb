class CreateHappinessScores < ActiveRecord::Migration[7.2]
  def change
    create_table :happiness_scores do |t|
      t.integer :value

      t.timestamps
    end
  end
end
