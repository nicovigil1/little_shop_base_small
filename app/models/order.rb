class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  enum status: [:pending, :completed, :cancelled]

  def self.top_3_states
    Order.joins(:user, :order_items)
      .select('users.state, count(order_items.id) as order_count')
      .where("order_items.fulfilled = ?", true)
      .group('users.state')
      .order('order_count desc, users.state asc')
      .limit(3)
  end

  def self.top_3_cities
    Order.joins(:user, :order_items)
      .select('users.city, users.state, count(order_items.id) as order_count')
      .where("order_items.fulfilled = ?", true)
      .group('users.state, users.city')
      .order('order_count desc, users.city asc, users.state asc')
      .limit(3)
  end

  def self.top_3_quantity_orders
    Order.joins(:user, :order_items)
      .select('users.name as user_name, sum(order_items.quantity) as total_quantity')
      .where('order_items.fulfilled=?', true)
      .order('total_quantity desc, user_name asc')
      .group(:id, 'users.id')
      .limit(3)
  end

  def last_update
    order_items.maximum(:updated_at)
  end

  def total_item_count
    order_items.sum(:quantity)
  end

  def total_cost
    oi = order_items.pluck("sum(quantity*price)")
    oi.sum
  end

  def my_item_count(merchant_id)
    self.order_items
      .joins(:item)
      .where("items.merchant_id=?", merchant_id)
      .pluck("sum(order_items.quantity)")
      .first.to_i
  end

  def my_revenue_value(merchant_id)
    self.order_items
      .joins(:item)
      .where("items.merchant_id=?", merchant_id)
      .pluck("sum(order_items.quantity * order_items.price)")
      .first.to_i
  end

  def my_items(merchant_id)
    Item.joins(order_items: :order)
      .where(
        :merchant_id => merchant_id,
        :"orders.id" => self.id,
        :"orders.status" => :pending
      )
  end

  def item_price(item_id)
    order_items.where(item_id: item_id).pluck(:price).first
  end

  def item_quantity(item_id)
    order_items.where(item_id: item_id).pluck(:quantity).first
  end

  def item_fulfilled?(item_id)
    order_items.where(item_id: item_id).pluck(:fulfilled).first
  end

  def discounts(order_item)
    order_item.user.discounts 
  end 

  def find_order_items
    test = Order.find(self.id).order_items
  end

  def update_price_by_quantity
    find_order_items.each do |order_item|
      discounts(order_item).each do |discount|
        if discount.quantity.include?(order_item.quantity) && (order_item.user == discount.user)
          order_item.update(price: ((order_item.price * order_item.quantity).to_i - discount.amount_off))
        end
      end
    end
  end

  def update_price_by_subtotal
    find_order_items.each do |order_item|
      subtotal = order_item.price * order_item.quantity
      discount = discounts(order_item).where("item_total <= ?", subtotal)
                 .order(item_total: :desc).limit(1)[0]
      new_price = subtotal * ((100 - discount.amount_off)/100.to_d)
      test = order_item.update(price: new_price)
    end 
  end 

  def apply_discounts(type) 
    type == "subtotal" ? "subtotal" : "quantity"

    if type == "subtotal"
      update_price_by_subtotal
    elsif type == "quantity"
      update_price_by_quantity
    end
  end 
end