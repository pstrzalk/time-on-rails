class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.datetime :started
      t.datetime :finished
      t.belongs_to :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
