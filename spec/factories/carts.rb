FactoryBot.define do  
 factory :cart do
    total_price { 0 }
    abandoned { false }
    last_interaction_at { Time.current }
    
    trait :with_items do
      transient do
        items_count { 2 }
      end
      
      after(:create) do |cart, evaluator|
        create_list(:cart_item, evaluator.items_count, cart: cart)
        cart.update_total!
      end
    end
    
    trait :abandoned do
      abandoned { true }
    end
    
    trait :not_abandoned do
      abandoned { false }
    end
  end
end