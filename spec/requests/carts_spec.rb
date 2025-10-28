require 'rails_helper'

RSpec.describe "/carts", type: :request do
  #pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"
  
    describe "POST /add_items" do
    let(:cart) { Cart.create!(total_price: 0) }
    let(:product) { Product.create!(name: "Test Product", price: 10.0) }
    let(:product1) { Product.create!(name: "Test Product 2", price: 20.0) }
    let!(:cart_item) { CartItem.create!(cart: cart, product: product, quantity: 1) }

      context 'when the product already is in the cart' do
        subject do
          post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
          post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        end

        it 'updates the quantity of the existing item in the cart' do
          expect(cart_item.reload.quantity).to eq(1)
        end
      end
    end

       context 'when adding a new product' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, name: "Test Product", price: 10.0) }
      let(:product1) { create(:product, name: "Test Product 2", price: 20.0) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      it 'adds the product to the cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })
        post '/cart/add_item', params: { product_id: product1.id, quantity: 2 }, as: :json
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['products'].length).to eq(2)
      end
    end

    describe "GET /show" do
      context 'when cart does not exist' do
        it 'creates a new cart and returns it' do
          get '/cart', as: :json
          
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['id']).to be_present
          expect(json_response['products']).to eq([])
          expect(json_response['total_price']).to eq("0.0")
        end
      end
    end

    describe 'POST /cart' do
      let(:product) { create(:product) }
      context 'when product does not exist' do
        it 'returns not found error' do
          post '/cart', params: { product_id: 99999, quantity: 1 }
          
          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to have_key('error')
        end
      end
    
      context 'when quantity is zero' do
        it 'returns validation error' do
          post '/cart', params: { product_id: product.id, quantity: 0 }
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('errors')
        end
      end
  end

end
