require 'rails_helper'
describe "on the dashboard" do
    it 'tells you which images you need to add a thumbnail for' do 
        merchant = create(:merchant)
        item1= create(:item, image: nil)
        item2 = create(:item, image: nil)
        item3 = create(:item, image: nil)
        item4 = create(:item)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

        visit dashboard_path

        within "#to-do" do 
            expect(page).to have_content(item1.name) 
            expect(page).to have_content(item2.name) 
            expect(page).to_not have_content(item4.name)
            click_on item_1.name
        end 

        expect(current_path).to eq(edit_dashboard_item_path(item1))
    end 

    xit "shows you unfufilled items & how much money you're missing out on" do
        merchant = create(:merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
        order = create(:order)
        item1 = create(:item)
        item2 = create(:item)
        item3 = create(:item)
        oi_1 = create(:order_item, item: item1, order: order)
        oi_2 = create(:order_item, item: item2, order: order)
        oi_3 = create(:fufilled_order_item, item: item3, order: order)

        visit dashboard_path

        within "#to-do-fufilled" do 
            expect(page).to have_content(oi_1.name) 
            expect(page).to have_content(oi_2.name) 
            expect(page).to_not have_content(oi_3.name)
        end 
    end 
end
