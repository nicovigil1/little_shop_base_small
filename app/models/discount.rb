class Discount < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount_off
  validates_presence_of :quantity, unless: :item_total?
  validates_presence_of :item_total, unless: :quantity?
  #fixme: cannot be negative quantity or subtotal

end
