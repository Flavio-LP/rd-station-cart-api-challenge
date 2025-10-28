require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    subject { build(:product) }
    
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end
  
  describe 'associations' do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:carts).through(:cart_items) }
  end
  
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:product)).to be_valid
    end
    
    it 'creates expensive product trait' do
      product = build(:product, :expensive)
      expect(product.price).to eq(50000)
    end
    
    it 'creates cheap product trait' do
      product = build(:product, :cheap)
      expect(product.price).to eq(500)
    end
  end
  
  describe 'database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:price).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
end