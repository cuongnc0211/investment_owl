class CreateTransaction < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :source, null: true, foreign_key: { to_table: :invesments }
      t.references :target, null: true, foreign_key: { to_table: :invesments }
      t.string :note
      t.integer :amount_cents

      t.timestamps
    end
  end
end
