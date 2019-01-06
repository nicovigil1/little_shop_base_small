require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do 
    it { should belong_to :user }
    it { should validate_presence_of :amount_off }

    context "quantity is required without presence of item_total" do 
      subject {Discount.new(amount_off: 30)}

      it { should validate_presence_of :quantity }
    end 

    context "quantity isn't required with presence of item_total" do 
      subject {Discount.new(amount_off: 30, item_total: 20)} 

      it { should_not validate_presence_of :quantity }
    end 

    context "item_total is required without quantity" do 
      subject {Discount.new(amount_off: 30)}

      it { should validate_presence_of :item_total }
    end 

    context "item_total isn't required if there is quantity" do 
      subject {Discount.new(amount_off: 30, quantity: 20)}

      it { should_not validate_presence_of :item_total }
    end
  end

  describe "discounts affect order item price" do
    it 'can affect order item price based on quantity' do 
      merchant = create(:merchant)
      user = create(:user)
      discount1 = create(:discount, amount_off: 5, quantity: 1..1, user: merchant)
      discount2 = create(:discount, amount_off: 5, quantity: 2..4, user: merchant)
      item = create(:item, user: merchant, price: 20)
      order = create(:completed_order, user: user)            
      order_item_1= create(:order_item, item: item, order: order, quantity:1, price:20)
      order_item_2 = create(:order_item, item: item, order: order, quantity:4, price:20)

      order.apply_discounts("quantity")    

      order_item_1.reload
      order_item_2.reload 

      expect(order_item_1.price).to eq(15.to_d)
      expect(order_item_2.price).to eq(75.to_d)
    end

    it 'can affect order item price based on subtotal' do 
      merchant = create(:merchant)
      user = create(:user)
      discount1 = create(:discount, amount_off: 5, quantity: nil, item_total: 25, user: merchant)
      discount2 = create(:discount, amount_off: 10, quantity: nil, item_total: 50, user: merchant)
      item = create(:item, user: merchant, price: 20)
      order = create(:completed_order, user: user)            
      order_item_1= create(:order_item, item: item, order: order, quantity:2, price:20)
      order_item_2 = create(:order_item, item: item, order: order, quantity:4, price:20)

      order.apply_discounts("subtotal")    

      order_item_1.reload
      order_item_2.reload 

      expect(order_item_1.price).to eq(38.to_d)
      expect(order_item_2.price).to eq(72.to_d)
    end
  end
end
