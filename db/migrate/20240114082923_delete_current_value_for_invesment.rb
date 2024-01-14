class DeleteCurrentValueForInvesment < ActiveRecord::Migration[7.1]
  def change
    remove_column :invesments, :current_value_cents, :integer
  end
end
