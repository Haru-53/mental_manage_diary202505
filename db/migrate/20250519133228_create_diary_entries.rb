class CreateDiaryEntries < ActiveRecord::Migration[7.0]
  def change
    # テーブルが存在しない場合のみ作成
    unless table_exists?(:diary_entries)
      create_table :diary_entries do |t|
        t.date :date, null: false
        t.integer :happiness_level
        t.text :good_things
        t.text :reflection
        t.text :notes
        t.references :user, null: false, foreign_key: true
        
        t.timestamps
      end
    end
    
    # インデックスが存在しない場合のみ追加
    unless index_exists?(:diary_entries, [:user_id, :date])
      add_index :diary_entries, [:user_id, :date], unique: true
    end
  end
end
