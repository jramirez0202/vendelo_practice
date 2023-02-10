class ProductsController < ApplicationController
    
    def index

        @categories = Category.all.order(name: :asc).load_async
        @products = Product.all.with_attached_photo.order(created_at: :desc).load_async
        if params[:category_id]
            @products = @products.where(category_id: params[:category_id])
        end
    end

    def show
        product
    end

    def new
        @product = Product.new
    end

    def edit
        product
    end

    def image
        @products = Product.all
    end

    def update
        product

        if @product.update(product_params)
            redirect_to products_path, notice: 'product was successfully updated.'
        else
            render :edit, status: :unprocessable_entity
        end   
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to products_path, notice: 'Product was successfully created'
        else
            render :new, status: :unprocessable_entity
        end
    end 

    def destroy
        product.destroy
    
        respond_to do |format|
          format.html { redirect_to products_url, notice: 'Product was deleted' }
          format.json { head :no_content }
        end
      end
    
    private

    def product_params
        params.require(:product).permit(:title, :description, :price, :photo, :category_id)
    end

    def product
        @product = Product.find(params[:id])
    end
    
end