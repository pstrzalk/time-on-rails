class RenameStartedToStartedAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :works, :started, :started_at
  end
end
