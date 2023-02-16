class ProductsController < ApplicationController
    
    def index
        @categories = Category.all.order(name: :asc).load_async
        @products = Product.all.with_attached_photo
        #filtrado para category_id
        if params[:category_id]
            @products = @products.where(category_id: params[:category_id])
        end
        #filtrado para max y min price
        if params[:min_price].present?
            @products = @products.where('price >= ?', params[:min_price])
        end
        if params[:max_price].present?
            @products = @products.where('price <= ?', params[:max_price])
        end

        #filtrado para title and descriotion
        if params[:query_text].present?
            @products = @products.search_full_text(params[:query_text])
        end

        # aqui evitamos evaluar el order_by.present? porque al  metodo fetch le agregamos que
        # si no esta presente un valor en order_by pues traiga por defecto 'created_at DESC' ver fetch

        if params[:order_by].present?
            order_by = Product::ORDER_BY.fetch(params[:order_by].to_sym, Product::ORDER_BY[:newest])
            #agregar al metodo orden las querys de hash dependiendo cual de las 3 esto es lo que pasa
            # @products = @products.order('created_at DESC')
            @products = @products.order(order_by).load_async
        end
        @pagy, @products = pagy_countless(@products, items: 12)
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