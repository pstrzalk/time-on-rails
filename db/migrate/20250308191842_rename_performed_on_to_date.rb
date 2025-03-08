class RenamePerformedOnToDate < ActiveRecord::Migration[8.0]
  def change
    rename_column :works, :performed_on, :date
  end
end
