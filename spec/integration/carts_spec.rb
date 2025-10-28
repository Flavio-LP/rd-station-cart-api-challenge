require 'swagger_helper'

RSpec.describe 'Carts API', type: :request do
  path '/cart' do
    post 'Creates a cart and adds a product' do
      tags 'Carts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :cart_params, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer },
          quantity: { type: :integer }
        },
        required: ['product_id', 'quantity']
      }

      response '201', 'cart created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            products: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  quantity: { type: :integer },
                  unit_price: { type: :string },
                  total_price: { type: :string }
                }
              }
            },
            total_price: { type: :string }
          }
        
        let(:product) { create(:product) }
        let(:cart_params) { { product_id: product.id, quantity: 2 } }
        run_test!
      end
    end

    get 'Shows the current cart' do
      tags 'Carts'
      produces 'application/json'

      response '200', 'cart found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            products: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  quantity: { type: :integer },
                  unit_price: { type: :string },
                  total_price: { type: :string }
                }
              }
            },
            total_price: { type: :string }
          }
        run_test!
      end
    end
  end

  path '/cart/add_item' do
    post 'Adds an item to the cart' do
      tags 'Carts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :item_params, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer },
          quantity: { type: :integer }
        },
        required: ['product_id', 'quantity']
      }

      response '200', 'item added' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            products: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  quantity: { type: :integer },
                  unit_price: { type: :string },
                  total_price: { type: :string }
                }
              }
            },
            total_price: { type: :string }
          }
        
        let(:product) { create(:product) }
        let(:item_params) { { product_id: product.id, quantity: 1 } }
        run_test!
      end
    end
  end

  path '/cart/{product_id}' do
    parameter name: :product_id, in: :path, type: :integer

    delete 'Removes an item from the cart' do
      tags 'Carts'
      produces 'application/json'

      response '200', 'item removed' do
       schema type: :object,
          properties: {
            id: { type: :integer },
            products: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  quantity: { type: :integer },
                  unit_price: { type: :string },
                  total_price: { type: :string }
                }
              }
            },
            total_price: { type: :string }
          }
        
        let(:product) { create(:product) }
        let(:product_id) { product.id }
        
        before do
          post '/cart', params: { product_id: product.id, quantity: 1 }
        end
        
        run_test!
      end

      response '404', 'product not found in cart' do
        let(:product_id) { 99999 }
        run_test!
      end
    end
  end
end