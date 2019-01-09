class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def subtract_item(item_id)
    @contents[item_id.to_s] -= 1
    @contents.delete(item_id.to_s) if @contents[item_id.to_s] == 0
  end

  def remove_all_of_item(item_id)
    @contents.delete(item_id.to_s)
  end

  def items
    @contents.keys.map do |item_id|
      Item.includes(:user).find(item_id)
    end
  end

  def subtotal(item_id)
    item = Item.find(item_id)
    merchant = item.user
    discounts = merchant.discounts_by_type(merchant.discount_type)
    if merchant.discount_type == 0
      applicable_discount = discounts.find do |discount|
        discount.quantity.include?(count_of(item_id))
      end
      percent_off = ((100 - applicable_discount.amount_off.to_f)/100)
      (item.price * count_of(item_id)) * percent_off if applicable_discount
    elsif merchant.discount_type == 1
      applicable_discount = discounts.find do |discount|
        discount.item_total > count_of(item_id)
      end
      (item.price * count_of(item_id)) - applicable_discount.amount_off if applicable_discount
    elsif merchant.discount_type == 2
      (item.price * count_of(item_id))
    end 
  end

  def grand_total
    @contents.keys.map do |item_id|
      subtotal(item_id)
    end.sum
  end
end