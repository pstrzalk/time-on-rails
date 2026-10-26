class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.references :user, null: false, foreign_key: true
      t.string :path, null: false
      t.timestamps
    end

    add_index :page_views, [ :user_id, :created_at ]
    add_index :page_views, [ :user_id, :path ]
  end
end
