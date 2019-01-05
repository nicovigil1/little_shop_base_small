FactoryBot.define do
  factory :discount do
    amount_off { 1 }
    quantity { "" }
    item_total { 1 }
    user { nil }
  end
end
