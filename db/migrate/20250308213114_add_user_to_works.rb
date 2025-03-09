class AddUserToWorks < ActiveRecord::Migration[8.0]
  def change
    add_reference :works, :user
  end
end
