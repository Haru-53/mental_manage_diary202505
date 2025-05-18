class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.text :content

      t.timestamps
    end

  add_index :diary_entries, [:user_id, :date], unique: true
  remove_index :diary_entries, :date
  end
end
