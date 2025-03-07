class AddDescriptionToWorks < ActiveRecord::Migration[8.0]
  def change
    add_column :works, :description, :text, default: ""
  end
end
