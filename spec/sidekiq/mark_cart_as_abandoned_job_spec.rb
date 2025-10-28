require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    let!(:inactive_cart) { create(:cart, :not_abandoned, last_interaction_at: 4.hours.ago) }
    let!(:active_cart) { create(:cart, :not_abandoned, last_interaction_at: 1.hour.ago) }
    let!(:already_abandoned_cart) { create(:cart, :abandoned, last_interaction_at: 5.hours.ago) }

    it 'marks inactive carts as abandoned' do
      described_class.new.perform
      expect(inactive_cart.reload.abandoned).to be true
    end

    it 'does not mark active carts as abandoned' do
      described_class.new.perform
      expect(active_cart.reload.abandoned).to be false
    end

    it 'does not change already abandoned carts' do
      described_class.new.perform
      expect(already_abandoned_cart.reload.abandoned).to be true
    end

    it 'marks carts inactive for more than 3 hours' do
      expect {
        described_class.new.perform
      }.to change { Cart.abandoned_carts.count }.by(1)
    end

    it 'logs the number of carts marked as abandoned' do
      expect(Rails.logger).to receive(:info).with("Marked 1 carts as abandoned")
      described_class.new.perform
    end

    it 'is in the default queue' do
      expect(described_class.queue).to eq('default')
    end

    it 'can be enqueued' do
      expect {
        MarkCartAsAbandonedJob.perform_async
      }.to change(Sidekiq::Queues["default"], :size).by(1)
    end

    context 'with multiple inactive carts' do
      let!(:inactive_cart_2) { create(:cart, :not_abandoned, last_interaction_at: 6.hours.ago) }
      let!(:inactive_cart_3) { create(:cart, :not_abandoned, last_interaction_at: 10.hours.ago) }

      it 'marks all inactive carts as abandoned' do
        expect {
          described_class.new.perform
        }.to change { Cart.abandoned_carts.count }.by(3)
      end
    end

    context 'with carts at the boundary' do
      let!(:boundary_cart) { create(:cart, :not_abandoned, last_interaction_at: 3.hours.ago) }

      it 'marks carts exactly at 3 hours as abandoned' do
        described_class.new.perform
        expect(boundary_cart.reload.abandoned).to be true
      end
    end

    context 'with cart items' do
      let(:product) { create(:product, name: "Test Product", price: 10.0) }
      let!(:cart_with_items) { create(:cart, :not_abandoned, last_interaction_at: 5.hours.ago) }
      let!(:cart_item) { create(:cart_item, cart: cart_with_items, product: product, quantity: 2) }

      it 'marks carts with items as abandoned' do
        described_class.new.perform
        expect(cart_with_items.reload.abandoned).to be true
      end

      it 'does not remove cart items when marking as abandoned' do
        expect {
          described_class.new.perform
        }.not_to change(CartItem, :count)
      end
    end
  end
end