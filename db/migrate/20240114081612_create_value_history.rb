class CreateValueHistory < ActiveRecord::Migration[7.1]
  def change
    create_table :value_histories do |t|
      t.references :invesment, null: false, foreign_key: true

      t.integer :previous_value_cents
      t.integer :previous_record_id
      t.integer :current_value_cents

      t.timestamps
    end
  end
end
