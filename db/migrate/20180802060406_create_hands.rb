class CreateHands < ActiveRecord::Migration[5.2]
  def change
    create_table :hands do |t|
      t.integer     :level
      t.integer     :level_time
      t.integer     :hand_limit
      t.integer     :small_blind
      t.integer     :big_blind
      t.integer     :ante
      t.integer     :players_dealt
      t.string      :position
      t.integer     :start_pot
      t.integer     :start_stack
      t.integer     :final_stack
      t.integer     :state
      t.string      :hole_cards, array: true, default: []
      t.string      :table_cards, array: true, default: []
      t.string      :villains_json
      t.string      :steps_json

      t.references  :session, foreign_key: true
      t.references  :user, foreign_key: true

      t.timestamps
    end
  end
end
