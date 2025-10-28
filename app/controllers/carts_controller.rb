class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui
  before_action :set_or_create_cart, only: [:show, :create, :add_item, :destroy_item]

  def show
    render json: cart_response
  end

  def create
    add_product_to_cart
    render json: cart_response, status: :created
  end

  def add_item
    add_product_to_cart
    render json: cart_response
  end

  def destroy_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product_id: product.id)
    
    if cart_item
      cart_item.destroy
      @cart.update_total!
      render json: cart_response
    else
      render json: { error: 'Product not found in cart' }, status: :not_found
    end
  end

  private

  def set_or_create_cart
    @cart = Cart.find_by(id: session[:cart_id])
    
    if @cart.nil?
      @cart = Cart.create!(total_price: 0, last_interaction_at: Time.current, abandoned: false)
      session[:cart_id] = @cart.id
    else
      @cart.update!(last_interaction_at: Time.current)
    end
  end

  def add_product_to_cart
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!
    @cart.update_total!
  end

  def cart_response
    {
      id: @cart.id,
      products: @cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.product.price * item.quantity
        }
      end,
      total_price: @cart.total_price
    }
  end
end