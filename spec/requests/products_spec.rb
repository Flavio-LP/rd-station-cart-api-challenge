require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:valid_attributes) { { name: 'Test Product', price: 1000 } }
  let(:invalid_attributes) { { name: '', price: -100 } }
  let(:json_response) { JSON.parse(response.body) }

  describe 'GET /products' do
    let!(:products) { create_list(:product, 5) }
    
    before { get products_path }
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns all products' do
      expect(json_response.size).to eq(5)
    end
    
    it 'returns products with correct structure' do
      expect(json_response.first).to include('id', 'name', 'price', 'created_at', 'updated_at')
    end
    
    context 'with pagination' do
      let!(:many_products) { create_list(:product, 30) }
      
      it 'paginates results' do
        get products_path, params: { page: 1, per_page: 10 }
        expect(json_response.size).to eq(10)
      end
    end
  end

  describe 'GET /products/:id' do
    let(:product) { create(:product) }
    
    before { get product_path(product) }
    
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns the product' do
      expect(json_response['id']).to eq(product.id)
      expect(json_response['name']).to eq(product.name)
      expect(json_response['price']).to eq(product.price)
    end
    
    context 'when product does not exist' do
      it 'returns not found' do
        get product_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /products' do
    context 'with valid parameters' do
      it 'creates a new Product' do
        expect {
          post products_path, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it 'returns http created' do
        post products_path, params: { product: valid_attributes }
        expect(response).to have_http_status(:created)
      end
      
      it 'returns the created product' do
        post products_path, params: { product: valid_attributes }
        expect(json_response['name']).to eq('Test Product')
        expect(json_response['price']).to eq(1000)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Product' do
        expect {
          post products_path, params: { product: invalid_attributes }
        }.not_to change(Product, :count)
      end

      it 'returns unprocessable entity' do
        post products_path, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /products/:id' do
    let(:product) { create(:product) }
    let(:new_attributes) { { name: 'Updated Product', price: 2000 } }

    context 'with valid parameters' do
      it 'updates the product' do
        patch product_path(product), params: { product: new_attributes }
        product.reload
        expect(product.name).to eq('Updated Product')
        expect(product.price).to eq(2000)
      end

      it 'returns http success' do
        patch product_path(product), params: { product: new_attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        patch product_path(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /products/:id' do
    let!(:product) { create(:product) }

    it 'destroys the product' do
      expect {
        delete product_path(product)
      }.to change(Product, :count).by(-1)
    end

    it 'returns http no content' do
      delete product_path(product)
      expect(response).to have_http_status(:no_content)
    end
    
    context 'when product is in carts' do
      let!(:cart_item) { create(:cart_item, product: product) }
      
      it 'destroys product and associated cart items' do
        expect {
          delete product_path(product)
        }.to change(Product, :count).by(-1)
         .and change(CartItem, :count).by(-1)
      end
    end
  end
end