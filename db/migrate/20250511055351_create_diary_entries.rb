class CreateDiaryEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :diary_entries do |t|
      t.date :date, null: false
      t.text :good_things, null: false
      t.text :reflection, null: false
      t.text :notes
      t.integer :happiness_level

      t.timestamps
    end
    
    add_index :diary_entries, :date, unique: true
  end
end
