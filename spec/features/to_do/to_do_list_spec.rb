require 'rails_helper'
describe "on the dashboard" do
    it 'tells you which images you need to add a thumbnail for' do 
        merchant = create(:merchant)
        item1= create(:item, image: 'https://picsum.photos/200/300/?image=524', user: merchant)
        item2 = create(:item, image: 'https://picsum.photos/200/300/?image=524', user: merchant)
        item3 = create(:item, image: 'https://picsum.photos/200/300/?image=524', user: merchant)
        item4 = create(:item)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        visit dashboard_path

        within "#to-do" do 
            expect(page).to have_link(item1.name) 
            expect(page).to have_link(item2.name) 
            expect(page).to_not have_link(item4.name)
            click_on item1.name
        end 

        expect(current_path).to eq(edit_dashboard_item_path(item1))
    end 

    it "shows you unfufilled items & how much money you're missing out on" do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
        order = create(:order)
        item1 = create(:item, user: merchant)
        item2 = create(:item, user: merchant)
        item3 = create(:item, user: merchant)
        oi_1 = create(:order_item, item: item1, order: order)
        oi_2 = create(:order_item, item: item2, order: order)
        oi_3 = create(:fulfilled_order_item, item: item3, order: order)

        visit dashboard_path

        within "#to-do-fulfilled" do 
            expect(page).to have_content(merchant.unfulfilled_orders_count) 
            expect(merchant.unfulfilled_orders_count).to eq(2)
            expect(page).to have_content(merchant.unfulfilled_orders_revenue) 
        end 
    end 
end
