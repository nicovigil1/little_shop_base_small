class AddDiscountTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount_type, :integer, default: 2
  end
end
