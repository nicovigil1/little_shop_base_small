class AddTypeToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :type, :integer, default: 2
  end
end
