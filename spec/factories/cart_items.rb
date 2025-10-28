FactoryBot.define do
  factory :cart_item do
    association :cart
    association :product
    quantity { 1 }
    
    trait :multiple_quantity do
      quantity { 5 }
    end
    
    trait :with_expensive_product do
      association :product, :expensive
    end
    
    trait :with_cheap_product do
      association :product, :cheap
    end
  end
end