require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:valid_attributes) { {} }
  let(:invalid_attributes) { { abandoned: 'invalid' } }
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET /carts' do
    let!(:carts) { create_list(:cart, 3) }
    
    before { get carts_path }
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns all carts' do
      expect(json_response.size).to eq(3)
    end
    
    it 'returns carts with correct structure' do
      expect(json_response.first).to include('id', 'abandoned', 'created_at', 'updated_at')
    end
    
    context 'with abandoned filter' do
      let!(:abandoned_cart) { create(:cart, :abandoned) }
      let!(:active_cart) { create(:cart, :not_abandoned) }
      
      it 'filters abandoned carts' do
        get carts_path, params: { abandoned: true }
        expect(json_response.map { |c| c['id'] }).to include(abandoned_cart.id)
        expect(json_response.map { |c| c['id'] }).not_to include(active_cart.id)
      end
    end
  end

  describe 'GET /carts/:id' do
    let(:cart) { create(:cart, :with_items, items_count: 2) }
    
    before { get cart_path(cart) }
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns the cart' do
      expect(json_response['id']).to eq(cart.id)
    end
    
    it 'includes cart items' do
      expect(json_response).to have_key('cart_items')
      expect(json_response['cart_items'].size).to eq(2)
    end
    
    it 'includes products in cart items' do
      expect(json_response['cart_items'].first).to have_key('product')
    end
    
    context 'when cart does not exist' do
      it 'returns not found' do
        get cart_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /carts' do
    context 'with valid parameters' do
      it 'creates a new Cart' do
        expect {
          post carts_path, params: { cart: valid_attributes }
        }.to change(Cart, :count).by(1)
      end

      it 'returns http created' do
        post carts_path, params: { cart: valid_attributes }
        expect(response).to have_http_status(:created)
      end
      
      it 'returns the created cart' do
        post carts_path, params: { cart: valid_attributes }
        expect(json_response).to have_key('id')
        expect(json_response['abandoned']).to be false
      end
      
      it 'schedules abandoned cart job' do
        expect(MarkCartAsAbandonedJob).to receive(:perform_in).with(3.hours, kind_of(Integer))
        post carts_path, params: { cart: valid_attributes }
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Cart' do
        expect {
          post carts_path, params: { cart: invalid_attributes }
        }.not_to change(Cart, :count)
      end

      it 'returns unprocessable entity' do
        post carts_path, params: { cart: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /carts/:id' do
    let(:cart) { create(:cart, :not_abandoned) }
    let(:new_attributes) { { abandoned: true } }

    context 'with valid parameters' do
      it 'updates the cart' do
        patch cart_path(cart), params: { cart: new_attributes }
        cart.reload
        expect(cart.abandoned).to be true
      end

      it 'returns http success' do
        patch cart_path(cart), params: { cart: new_attributes }
        expect(response).to have_http_status(:success)
      end
      
      it 'returns the updated cart' do
        patch cart_path(cart), params: { cart: new_attributes }
        expect(json_response['abandoned']).to be true
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        patch cart_path(cart), params: { cart: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
    context 'when cart does not exist' do
      it 'returns not found' do
        patch cart_path(id: 999999), params: { cart: new_attributes }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /carts/:id' do
    let!(:cart) { create(:cart) }

    it 'destroys the cart' do
      expect {
        delete cart_path(cart)
      }.to change(Cart, :count).by(-1)
    end

    it 'returns http no content' do
      delete cart_path(cart)
      expect(response).to have_http_status(:no_content)
    end
    
    context 'when cart does not exist' do
      it 'returns not found' do
        delete cart_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
    
    context 'when cart has items' do
      let!(:cart_with_items) { create(:cart, :with_items, items_count: 3) }
      
      it 'destroys cart and associated items' do
        expect {
          delete cart_path(cart_with_items)
        }.to change(Cart, :count).by(-1)
         .and change(CartItem, :count).by(-3)
      end
    end
  end
  
  describe 'POST /carts/:id/add_item' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let(:valid_params) { { product_id: product.id, quantity: 2 } }
    
    context 'with valid parameters' do
      it 'adds item to cart' do
        expect {
          post add_item_cart_path(cart), params: valid_params
        }.to change(cart.cart_items, :count).by(1)
      end
      
      it 'returns http success' do
        post add_item_cart_path(cart), params: valid_params
        expect(response).to have_http_status(:success)
      end
      
      it 'returns the cart with items' do
        post add_item_cart_path(cart), params: valid_params
        expect(json_response['cart_items'].size).to eq(1)
      end
    end
    
    context 'when product already in cart' do
      before { create(:cart_item, cart: cart, product: product, quantity: 1) }
      
      it 'updates quantity' do
        post add_item_cart_path(cart), params: valid_params
        cart_item = cart.cart_items.find_by(product: product)
        expect(cart_item.quantity).to eq(3)
      end
    end
    
    context 'with invalid product' do
      it 'returns not found' do
        post add_item_cart_path(cart), params: { product_id: 999999, quantity: 1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  
  describe 'DELETE /carts/:id/remove_item' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }
    
    it 'removes item from cart' do
      expect {
        delete remove_item_cart_path(cart), params: { product_id: product.id }
      }.to change(cart.cart_items, :count).by(-1)
    end
    
    it 'returns http success' do
      delete remove_item_cart_path(cart), params: { product_id: product.id }
      expect(response).to have_http_status(:success)
    end
    
    context 'when item not in cart' do
      it 'returns not found' do
        delete remove_item_cart_path(cart), params: { product_id: 999999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end