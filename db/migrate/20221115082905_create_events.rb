class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :detail
      t.integer :spots
      t.text :address
      t.date :date
      t.time :time
      t.boolean :private
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
