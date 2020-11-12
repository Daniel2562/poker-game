class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :request, foreign_key: true
      t.integer :step
      t.string :comment

      t.timestamps
    end
  end
end
