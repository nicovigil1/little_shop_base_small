require 'rails_helper'

describe "when a user adds items to a cart" do
    it "applicable discounts are applied" do
        merchant = create(:merchant, discount_type: 0)
        merchant2 = create(:merchant, discount_type: 0)
        discount1 = create(:discount, amount_off: 5, quantity: 1..4, user: merchant, kind: 0)
        discount2 = create(:discount, amount_off: 10, quantity: 5..10, user: merchant, kind: 0)
        discount3 = create(:discount, amount_off: 15, quantity: 5..10, user: merchant2, kind: 0)
        item1 = create(:item, user: merchant, price: 100)
        item2 = create(:item, user: merchant2)
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        visit item_path(item1)
        click_button "Add to Cart"
        visit cart_path

        expect(page).to have_content("Total: $95.00")
    end

    it "applicable discounts are applied" do
        merchant = create(:merchant, discount_type: 1)
        merchant2 = create(:merchant, discount_type: 0)
        discount1 = create(:discount, amount_off: 5, item_total: 5, quantity: nil, user: merchant, kind: 1)
        discount2 = create(:discount, amount_off: 10, quantity: 5..10, user: merchant, kind: 0)
        discount3 = create(:discount, amount_off: 15, quantity: 5..10, user: merchant2, kind: 0)
        item1 = create(:item, user: merchant, price: 100)
        item2 = create(:item, user: merchant2)
        user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        visit item_path(item1)
        click_button "Add to Cart"
        visit cart_path

        expect(page).to have_content("Total: $95.00")
    end
end
