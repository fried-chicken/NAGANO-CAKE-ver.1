class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  
    def index
      @cart_items = current_customer.cart_items
      @total_price = @cart_items.sum{|cart_item|cart_item.item.price_without_tax * cart_item.quantity * 1.1}
    end

    def create
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.customer_id = current_customer.id
      @cart_item.item_id = params[:item_id]
        if @cart_item.save
          redirect_to customers_cart_items_path
        else
          render "customers/items/show"
        end
    end

    def update
      @cart_item = CartItem.find(params[:id])
      @cart_item.update(cart_item_params)
      redirect_to customers_cart_items_path
    end

    def destroy
      @cart_item = CartItem.find(params[:id])
      @cart_item.destroy
      redirect_to customers_cart_items_path
    end

    def all_destroy
      @cart_item = current_customer.cart_items
      @cart_item.destroy_all
      redirect_to customers_cart_items_path
    end

    private

    def cart_item_params
      params.require(:cart_item).permit(:quantity, :item_id, :customer_id)
    end

end