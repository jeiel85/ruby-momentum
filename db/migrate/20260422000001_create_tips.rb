class CreateTips < ActiveRecord::Migration[8.1]
  def change
    create_table :tips do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.integer :amount, null: false # in cents
      t.string :stripe_payment_intent_id
      t.string :status, default: "pending" # pending, succeeded, failed, refunded
      t.text :message # optional tip message
      t.timestamps
    end

    add_index :tips, :stripe_payment_intent_id
  end
end