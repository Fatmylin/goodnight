class InitializeGoodNight < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email
      t.string :name
      t.string :token

      t.timestamps null: false
    end

    create_table :sleep_records do |t|
      t.references :user, null: false, index: true
      t.datetime :start_at
      t.datetime :finish_at

      t.timestamps null: false
    end

    create_table :friendships do |t|
      t.references :user, null: false, index: true
      t.references :friend, null: false, index: true, forign_key: { to_table: "user" }
    end
  end
end
