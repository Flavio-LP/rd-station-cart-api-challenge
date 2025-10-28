require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'validations' do
    subject { build(:cart_item) }
    
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:cart) }
    it { is_expected.to validate_presence_of(:product) }
  end
  
  describe 'associations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end
  
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:cart_item)).to be_valid
    end
    
    it 'creates cart_item with multiple quantity' do
      cart_item = build(:cart_item, :multiple_quantity)
      expect(cart_item.quantity).to eq(5)
    end
    
    it 'creates cart_item with expensive product' do
      cart_item = create(:cart_item, :with_expensive_product)
      expect(cart_item.product.price).to eq(50000)
    end
    
    it 'creates cart_item with cheap product' do
      cart_item = create(:cart_item, :with_cheap_product)
      expect(cart_item.product.price).to eq(500)
    end
  end
  
  describe 'database columns' do
    it { is_expected.to have_db_column(:cart_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
  
  describe 'indexes' do
    it { is_expected.to have_db_index(:cart_id) }
    it { is_expected.to have_db_index(:product_id) }
    it { is_expected.to have_db_index([:cart_id, :product_id]).unique(true) }
  end
  
  describe '#subtotal' do
    let(:product) { create(:product, price: 1500) }
    let(:cart_item) { create(:cart_item, product: product, quantity: 3) }
    
    it 'calculates subtotal correctly' do
      expect(cart_item.subtotal).to eq(4500)
    end
  end
  
  describe 'uniqueness' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    
    it 'does not allow duplicate product in same cart' do
      create(:cart_item, cart: cart, product: product)
      duplicate = build(:cart_item, cart: cart, product: product)
      
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:product_id]).to include('has already been added to this cart')
    end
    
    it 'allows same product in different carts' do
      cart2 = create(:cart)
      create(:cart_item, cart: cart, product: product)
      duplicate = build(:cart_item, cart: cart2, product: product)
      
      expect(duplicate).to be_valid
    end
  end
end