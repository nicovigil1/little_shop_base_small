class Discount < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount_off
  validates_presence_of :item_total, unless: :quantity?
  validates_presence_of :quantity, unless: :item_total?
end
