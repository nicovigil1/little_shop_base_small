require "rails_helper"

describe "Discounts Behaviors" do
    
    context "Discounts work on order_items" do 
        it 'can lower the price of order_items' do 
            merchant = create(:merchant)
            user = create(:user)
            discount = create(:discount, amount_off: 5, quantity: 2..4, user: user)
            item = create(:item, user: merchant, price: 20)
            order = create(:completed_order, user: user)            
            order_item_1= create(:order_item, item: item, order: order, quantity:1)
            order_item_2 = create(:order_item, item: item, order: order, quantity:4)

            visit dashboard_order_path(order)

            expect(order_item_1.price).to eq(20)
            expect(order_item_2.price).to eq(15)

            within "#order_item-#{order_item_1.id}" do 
                expect(page).to have_content(20)
            end 

            within "#order_item-#{order_item_2.id}" do 
                expect(page).to have_content(15)
            end 
        end
    end

    context 'can either be percentage or dollar based' do 
        it "can be a dollar amount & based of the item's total" do 
            
        end

        it 'can be a percentage & based of quantity' do 
            
        end
    end 

end