FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:price) { |n| (10.0 + n) * 100 }
    
    trait :expensive do
      price { 50000 }
    end
    
    trait :cheap do
      price { 500 }
    end
  end
end