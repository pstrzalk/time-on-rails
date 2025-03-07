class AddDurationToWorks < ActiveRecord::Migration[8.0]
  def change
    add_column :works, :duration, :integer, default: 0
  end
end
