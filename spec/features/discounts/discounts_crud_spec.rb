require 'rails_helper'
describe 'Discounts CRUD' do
    describe "Read and Create" do 
        it "can see a link to add a bulk discount" do
            merchant = create(:merchant)
            merchant2 = create(:merchant)
            discount1 = create(:discount, amount_off: 5, quantity: 2..4, user: merchant)
            discount2 = create(:discount, amount_off: 10, quantity: 5..10, user: merchant)
            discount3 = create(:discount, amount_off: 15, quantity: 5..10, user: merchant2)

            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    
            visit dashboard_path
    
            expect(page).to have_content("My Discounts")
            
            click_link "My Discounts"

            expect(current_path).to eq(dashboard_discounts_path)

            within "#discount-#{discount1.id}" do 
                expect(page).to have_content("5")
            end

            within "#discount-#{discount2.id}" do 
                expect(page).to have_content("10")
            end

            within ".discounts-table" do 
                expect(page).to_not have_content("15")
            end
            
            expect(page).to have_link("Switch to Dollars & Item Subtotal")

            click_link "Add Discount"

            expect(current_path).to eq(new_dashboard_discount_path)

            
        end

        xit "Create quantity based percentage discounts" do 
            merchant = create(:merchant)
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

            visit new_dashboard_discount_path
            expect(page).to have_button("Dollars based off Item Subtotal") 
            expect(page).to have_button("Percentage based off Item Quantity") 
            click_on "Percentage based off Item Quantity"

            fill_in "Amount Off",	with: 5  
            fill_in "Min Req.",	with: 1
            fill_in "Max Req.",	with: 5
            click_on "Create Discount"

            expect(current_path).to eq(dashboard_discounts_path)
        end 
    end


    describe "Discounts Read" do
        xit 'can display the price of order_items' do 
            merchant = create(:merchant)
            user = create(:user)
            discount = create(:discount, amount_off: 5, quantity: 2..4, user: merchant)
            item = create(:item, user: merchant, price: 20)
            order = create(:completed_order, user: user)            
            order_item_1= create(:order_item, item: item, order: order, quantity:1, price: 20)
            order_item_2 = create(:order_item, item: item, order: order, quantity:4, price: 75)

            visit dashboard_order_path(order)

            within "#order_item-#{order_item_1.id}" do 
                expect(page).to have_content(20)
            end 

            within "#order_item-#{order_item_2.id}" do 
                expect(page).to have_content(75)
            end 
        end
    end
end