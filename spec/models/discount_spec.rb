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
    merchant = create(:merchant)
    user = create(:user)
    discount = create(:discount, amount_off: 5, quantity: 2..4, user: user)
    item = create(:item, user: merchant, price: 20)
    order = create(:completed_order, user: user)            
    order_item_1= create(:order_item, item: item, order: order, quantity:1)
    order_item_2 = create(:order_item, item: item, order: order, quantity:4)

    order.apply_discounts    

    expect(order_item_1.price).to eq(20)
    expect(order_item_2.price).to eq(15)
  end
  
  
end
