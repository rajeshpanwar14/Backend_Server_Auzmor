class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts, id: false do |t|
      t.integer :id, primary_key: true
      t.string :auth_id
      t.string :username

      t.timestamps
    end
  end
end