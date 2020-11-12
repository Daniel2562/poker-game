class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string      :title
      t.string      :game
      t.string      :kind
      t.integer     :level_time
      t.integer     :small_blind
      t.integer     :big_blind
      t.integer     :ante
      t.references  :user, foreign_key: true

      t.timestamps
    end
  end
end
