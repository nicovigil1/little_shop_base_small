class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      # FIXME: change amount off to decimal as well as item_total
      t.integer :amount_off
      t.int4range :quantity
      t.integer :item_total
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
