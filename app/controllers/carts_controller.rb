class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui
  before_action :set_cart, only: [:show, :add_item, :destroy_item]

  def show
    render json: cart_response
  end

  def create
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!
    
    update_cart_total
    render json: cart_response, status: :created
  end

  def add_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!
    
    update_cart_total
    render json: cart_response
  end

  def destroy_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)
    
    if cart_item
      cart_item.destroy
      update_cart_total
      render json: cart_response
    else
      render json: { error: 'Product not found in cart' }, status: :not_found
    end
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])
    
    if @cart.nil?
      @cart = Cart.create(total_price: 0, last_interaction_at: Time.current, abandoned: false)
      session[:cart_id] = @cart.id
    else
      @cart.update(last_interaction_at: Time.current)
    end
  end

  def update_cart_total
    total = @cart.cart_items.joins(:product).sum('products.price * cart_items.quantity')
    @cart.update(total_price: total)
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