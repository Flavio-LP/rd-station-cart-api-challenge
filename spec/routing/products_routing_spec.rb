require 'rails_helper'

RSpec.describe ProductsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/products').to route_to('products#index')
    end

    it 'routes to #show' do
      expect(get: '/products/1').to route_to('products#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/products').to route_to('products#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/products/1').to route_to('products#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/products/1').to route_to('products#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/products/1').to route_to('products#destroy', id: '1')
    end
  end
  
  describe 'named routes' do
    it 'generates products_path' do
      expect(products_path).to eq('/products')
    end
    
    it 'generates product_path' do
      expect(product_path(1)).to eq('/products/1')
    end
    
    it 'generates new_product_path' do
      expect(new_product_path).to eq('/products/new')
    end
    
    it 'generates edit_product_path' do
      expect(edit_product_path(1)).to eq('/products/1/edit')
    end
  end
end