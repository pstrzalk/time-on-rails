class DropFinishedFromWorks < ActiveRecord::Migration[8.0]
  def change
    remove_column :works, :finished
  end
end
