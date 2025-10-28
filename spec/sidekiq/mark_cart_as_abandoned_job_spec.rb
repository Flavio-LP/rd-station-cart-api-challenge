require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe '#perform' do
    let(:cart) { create(:cart, :not_abandoned) }
    
    it 'marks cart as abandoned' do
      expect {
        described_class.new.perform(cart.id)
      }.to change { cart.reload.abandoned }.from(false).to(true)
    end
    
    context 'when cart does not exist' do
      it 'does not raise error' do
        expect {
          described_class.new.perform(999999)
        }.not_to raise_error
      end
    end
    
    context 'when cart is already abandoned' do
      let(:abandoned_cart) { create(:cart, :abandoned) }
      
      it 'does not change abandoned status' do
        expect {
          described_class.new.perform(abandoned_cart.id)
        }.not_to change { abandoned_cart.reload.abandoned }
      end
    end
    
    it 'is in the default queue' do
      expect(described_class.queue).to eq('default')
    end
    
    it 'can be enqueued' do
      expect {
        described_class.perform_async(cart.id)
      }.to change(described_class.jobs, :size).by(1)
    end
    
    it 'can be scheduled' do
      expect {
        described_class.perform_in(3.hours, cart.id)
      }.to change(described_class.jobs, :size).by(1)
    end
  end
end