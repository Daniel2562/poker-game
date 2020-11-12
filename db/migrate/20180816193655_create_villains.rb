class CreateVillains < ActiveRecord::Migration[5.2]
  def change
    create_table :villains do |t|
      t.string :profile
      t.string :position
      t.integer :start_stack
      t.references :hand, foreign_key: true

      t.timestamps
    end
  end
end
