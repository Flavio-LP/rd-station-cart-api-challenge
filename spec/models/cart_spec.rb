require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:abandoned).in_array([true, false]) }
  end
  
  describe 'associations' do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:cart_items) }
  end
  
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:cart)).to be_valid
    end
    
    it 'creates cart with items' do
      cart = create(:cart, :with_items, items_count: 3)
      expect(cart.cart_items.count).to eq(3)
    end
    
    it 'creates abandoned cart' do
      cart = create(:cart, :abandoned)
      expect(cart.abandoned).to be true
    end
    
    it 'creates not abandoned cart' do
      cart = create(:cart, :not_abandoned)
      expect(cart.abandoned).to be false
    end
  end
  
  describe 'database columns' do
    it { is_expected.to have_db_column(:abandoned).of_type(:boolean) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
  
  describe 'default values' do
    it 'sets abandoned to false by default' do
      cart = create(:cart)
      expect(cart.abandoned).to be false
    end
  end
  
  describe '#total_price' do
    let(:cart) { create(:cart) }
    let(:product1) { create(:product, price: 1000) }
    let(:product2) { create(:product, price: 2000) }
    
    it 'calculates total price correctly' do
      create(:cart_item, cart: cart, product: product1, quantity: 2)
      create(:cart_item, cart: cart, product: product2, quantity: 1)
      
      expect(cart.total_price).to eq(4000)
    end
    
    it 'returns 0 for empty cart' do
      expect(cart.total_price).to eq(0)
    end
  end
  
  describe 'scopes' do
    describe '.abandoned' do
      let!(:abandoned_cart) { create(:cart, :abandoned) }
      let!(:active_cart) { create(:cart, :not_abandoned) }
      
      it 'returns only abandoned carts' do
        expect(Cart.abandoned).to include(abandoned_cart)
        expect(Cart.abandoned).not_to include(active_cart)
      end
    end
    
    describe '.not_abandoned' do
      let!(:abandoned_cart) { create(:cart, :abandoned) }
      let!(:active_cart) { create(:cart, :not_abandoned) }
      
      it 'returns only not abandoned carts' do
        expect(Cart.not_abandoned).to include(active_cart)
        expect(Cart.not_abandoned).not_to include(abandoned_cart)
      end
    end
    
    describe '.older_than' do
      let!(:old_cart) { create(:cart, created_at: 8.hours.ago) }
      let!(:recent_cart) { create(:cart, created_at: 2.hours.ago) }
      
      it 'returns carts older than specified time' do
        expect(Cart.older_than(3.hours)).to include(old_cart)
        expect(Cart.older_than(3.hours)).not_to include(recent_cart)
      end
    end
  end
  
  describe '#mark_as_abandoned!' do
    let(:cart) { create(:cart, :not_abandoned) }
    
    it 'marks cart as abandoned' do
      expect { cart.mark_as_abandoned! }.to change { cart.abandoned }.from(false).to(true)
    end
  end
end