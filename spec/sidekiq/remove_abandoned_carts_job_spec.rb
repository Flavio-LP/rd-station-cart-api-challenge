require 'rails_helper'

RSpec.describe RemoveAbandonedCartsJob, type: :job do
  describe '#perform' do
  let!(:old_abandoned_cart) { Cart.create!(abandoned: true, last_interaction_at: 8.days.ago, total_price: 0) }
  let!(:active_cart) { Cart.create!(abandoned: false, last_interaction_at: 8.days.ago, total_price: 0) }
  let!(:recent_abandoned_cart) { Cart.create!(abandoned: true, last_interaction_at: 1.day.ago, total_price: 0) }
    
    it 'removes old abandoned carts' do
      expect {
        described_class.new.perform
      }.to change(Cart, :count).by(-1)
      
      expect(Cart.exists?(old_abandoned_cart.id)).to be false
    end
    
    it 'keeps recent abandoned carts' do
      described_class.new.perform
      expect(Cart.exists?(recent_abandoned_cart.id)).to be true
    end
    
    it 'keeps active carts' do
      described_class.new.perform
      expect(Cart.exists?(active_cart.id)).to be true
    end
    
    it 'removes carts older than 7 days' do
      expect_any_instance_of(Cart).to receive(:destroy).once
      described_class.new.perform
    end
    
    it 'is in the default queue' do
      expect(described_class.queue).to eq('default')
    end
    
  it 'can be enqueued' do
    expect {
      RemoveAbandonedCartsJob.perform_async
    }.to change(Sidekiq::Queues["default"], :size).by(1)
  end

    
    context 'with cart items' do
      #let!(:cart_with_items) { Cart.create!(abandoned: true, last_interaction_at: 8.days.ago, total_price: 0) }
      let(:product1) { Product.create!(name: "Product 1", price: 10.0) }
      let!(:cart_item1) { CartItem.create!(cart: old_abandoned_cart, product: product1, quantity: 1) }

      it 'removes cart and associated items' do
        expect {
          described_class.new.perform
        }.to change(Cart, :count).by(-1)
        .and change(CartItem, :count).by(-1)
      end
    end
  end
end