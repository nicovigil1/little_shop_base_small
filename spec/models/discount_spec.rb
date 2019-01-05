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
  
end
