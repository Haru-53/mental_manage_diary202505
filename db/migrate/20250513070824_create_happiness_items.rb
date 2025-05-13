class CreateHappinessItems < ActiveRecord::Migration[7.2]
  def change
    create_table :happiness_items do |t|
      t.string :name
      t.text :description
      t.integer :weight
      t.boolean :satisfied

      t.timestamps
    end
  end
end
