class CreateInvesments < ActiveRecord::Migration[7.1]
  def change
    create_table :invesments do |t|
      t.string :name
      t.text :description
      t.integer :capital_cents
      t.datetime :capital_at
      t.integer :current_value_cents
      t.string :status

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
