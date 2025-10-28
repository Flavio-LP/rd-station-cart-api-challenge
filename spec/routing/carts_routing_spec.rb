require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create' do
      #pending "#TODO: Escreva um teste para validar a criação de um carrinho #{__FILE__}" 
      expect(post: '/cart').to route_to('carts#create')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to('carts#add_item')
    end

    it 'routes to #destroy_item with product_id parameter' do
      product = create(:product)
      expect(delete: "/cart/#{product.id}").to route_to('carts#destroy_item', product_id: product.id.to_s)
    end

    it 'generates the correct path for show' do
      expect(get: cart_path).to route_to('carts#show')
    end

    it 'generates the correct path for create' do
      expect(post: cart_path).to route_to('carts#create')
    end

    it 'generates the correct path for add_item' do
      expect(post: cart_add_item_path).to route_to('carts#add_item')
    end

  end
end 
