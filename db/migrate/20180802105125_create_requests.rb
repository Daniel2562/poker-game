class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.boolean :viewed
      t.boolean :resolved
      t.boolean :accepted
      t.string  :summary
      t.string  :payment

      t.integer :pro_id, foreign_key: true
      t.references :user, foreign_key: true
      t.references :hand, foreign_key: true

      t.timestamps
    end

    add_index :requests, :pro_id
  end
end
