class AddCurrencyToInvesment < ActiveRecord::Migration[7.1]
  def change
    add_column :invesments, :currency, :string, default: 'VND'
  end
end
