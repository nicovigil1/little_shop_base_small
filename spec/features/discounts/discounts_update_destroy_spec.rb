require 'rails_helper'

describe "As a merchant" do
  context "on my discounts index page" do
    it "there's a link to update discount parameters (percentage)" do
      merchant = create(:merchant, discount_type: 0)
      discount = create(:discount, amount_off: 10, quantity: 1..2, kind: 0, user: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_discounts_path
      within '.discounts' do 
        expect(page).to have_content(discount.amount_off)
      end

      within "#discount-#{discount.id}" do 
        click_link "Update"
      end

      expect(current_path).to eq(edit_dashboard_discount_path(discount))

      fill_in "Discount (in Percentage)",	with: "42"

      click_button "Update Discount"

      expect(current_path).to  eq(dashboard_discounts_path)
      save_and_open_page
      within("#discount-#{discount.id}") do 
        expect(page).to have_content(42)
      end
    end

    it "there's a link to update discount parameters (dollars)" do
      merchant = create(:merchant, discount_type: 1)
      discount = create(:discount, amount_off: 10, quantity: nil, item_total: 12, kind: 1, user: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_discounts_path
      within '.discounts' do 
        expect(page).to have_content(discount.amount_off)
      end

      within "#discount-#{discount.id}" do 
        click_link "Update"
      end

      expect(current_path).to eq(edit_dashboard_discount_path(discount))

      fill_in "Discount (in Dollars off)",	with: "42"

      click_on "Update Discount"

      expect(current_path).to  eq(dashboard_discounts_path)

      within "#discount-#{discount.id}" do 
        expect(page).to have_content(42)
      end
    end
  end
end
