require 'rails_helper'

RSpec.describe RemoveAbandonedCartsJob, type: :job do
  describe '#perform' do
    let!(:old_abandoned_cart) { create(:cart, :abandoned, created_at: 8.days.ago) }
    let!(:recent_abandoned_cart) { create(:cart, :abandoned, created_at: 2.days.ago) }
    let!(:active_cart) { create(:cart, :not_abandoned, created_at: 10.days.ago) }
    
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
        described_class.perform_async
      }.to change(described_class.jobs, :size).by(1)
    end
    
    context 'with cart items' do
      let!(:cart_with_items) { create(:cart, :abandoned, :with_items, created_at: 8.days.ago, items_count: 3) }
      
      it 'removes cart and associated items' do
        expect {
          described_class.new.perform
        }.to change(Cart, :count).by(-2)
         .and change(CartItem, :count).by(-3)
      end
    end
  end
end