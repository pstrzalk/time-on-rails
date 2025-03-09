class AddUserToProjects < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :user
  end
end
