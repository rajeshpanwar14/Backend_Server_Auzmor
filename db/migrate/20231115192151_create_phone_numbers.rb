class CreatePhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :phone_numbers, id: false do |t|
      t.integer :id, primary_key: true
      t.string :number
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end