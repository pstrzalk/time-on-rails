class AddDateToWorks < ActiveRecord::Migration[8.0]
  def change
    add_column :works, :performed_on, :date
  end
end
