class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.string :actor
      t.string :action
      t.integer :amount
      t.integer :stack
      t.string :title
      t.string :comment
      t.references :hand, foreign_key: true

      t.timestamps
    end
  end
end
