FactoryBot.define do  
  factory :cart do
    trait :with_items do
      transient do
        items_count { 2 }
      end
      
      after(:create) do |cart, evaluator|
        create_list(:cart_item, evaluator.items_count, cart: cart)
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