class AddTypeToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :kind, :integer, default: 2
  end
end
