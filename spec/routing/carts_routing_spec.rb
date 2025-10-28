require 'rails_helper'

RSpec.describe CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/carts').to route_to('carts#index')
    end

    it 'routes to #show' do
      expect(get: '/carts/1').to route_to('carts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/carts').to route_to('carts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/carts/1').to route_to('carts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/carts/1').to route_to('carts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/carts/1').to route_to('carts#destroy', id: '1')
    end
    
    it 'routes to #add_item' do
      expect(post: '/carts/1/add_item').to route_to('carts#add_item', id: '1')
    end
    
    it 'routes to #remove_item' do
      expect(delete: '/carts/1/remove_item').to route_to('carts#remove_item', id: '1')
    end
    
    it 'routes to #clear' do
      expect(delete: '/carts/1/clear').to route_to('carts#clear', id: '1')
    end
  end
  
  describe 'named routes' do
    it 'generates carts_path' do
      expect(carts_path).to eq('/carts')
    end
    
    it 'generates cart_path' do
      expect(cart_path(1)).to eq('/carts/1')
    end
    
    it 'generates add_item_cart_path' do
      expect(add_item_cart_path(1)).to eq('/carts/1/add_item')
    end
    
    it 'generates remove_item_cart_path' do
      expect(remove_item_cart_path(1)).to eq('/carts/1/remove_item')
    end
    
    it 'generates clear_cart_path' do
      expect(clear_cart_path(1)).to eq('/carts/1/clear')
    end
  end
end