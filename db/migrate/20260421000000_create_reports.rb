class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.integer :reason, null: false
      t.text :description
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :reports, [:user_id, :post_id], unique: true, where: "post_id IS NOT NULL"
    add_index :reports, [:user_id, :comment_id], unique: true, where: "comment_id IS NOT NULL"
  end
end