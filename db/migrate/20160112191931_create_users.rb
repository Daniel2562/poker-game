class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      t.string    :email
      t.string    :name
      t.string    :avatar
      t.string    :game_kinds, array: true, default: []

      t.boolean   :pro
      t.string    :ios_iap_id
      t.string    :android_iap_id
      t.string    :promo_code

      t.string    :applied_promo_code
      t.integer   :remaining_promo_requests

      t.string    :queen_salt
      t.string    :queen_hash

      t.string    :password_digest
      t.string    :auth_token

      t.string    :confirmation_token
      t.datetime  :confirmation_sent_at
      t.datetime  :confirmed_at

      t.string    :reset_password_digest
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :pro
    add_index :users, :ios_iap_id
    add_index :users, :android_iap_id
    add_index :users, :promo_code
    add_index :users, :email,                 unique: true
    add_index :users, :auth_token,            unique: true
    add_index :users, :confirmation_token,    unique: true
    add_index :users, :reset_password_token,  unique: true
  end
end
