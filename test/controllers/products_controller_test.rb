require 'test_helper'
class ProductControllerTest < ActionDispatch::IntegrationTest
    test 'render list of products in index' do
        get products_path

        assert_response :success
        assert_select '.product', 12
        assert_select '.category', 9
    end

    test 'render a list of products filtered by category' do
      get products_path(category_id: categories(:computers).id)

      assert_response :success
      assert_select '.product', 5

    end

    test 'render a list of products filtered by min and max price' do
      get products_path(min_price: 101, max_price: 400)

      assert_response :success
      assert_select '.product', 8
      assert_select 'span', 'Nintendo' 
    end

    test 'search a product by query_search' do
      get products_path(query_search:'Nintendo switch')

      assert_response :success
      assert_select '.product', 12
      assert_select 'span', 'Nintendo' 
    end

    test 'sort products by expensive prices first' do
      get products_path(order_by:'expensive')

      assert_response :success
      assert_select '.product', 12
      assert_select '.products .product:first-child span', 'Seat Panda clásico'
    end

    test 'sort products by chepeasr prices first' do
      get products_path(order_by:'cheapest')

      assert_response :success
      assert_select '.product', 12
      assert_select '.products .product:first-child span', 'El hobbit'
    end

    test 'render detailed product page' do
        get product_path(products(:ps4))

        assert_response :success
        assert_select '.title', 'PS4 Fat'
        assert_select '.description', 'PS4 en buen estado'
        assert_select '.price', '100'
    end

    test 'render new form products' do
        get new_product_path

        assert_response :success
        assert_select 'form'
    end

    test 'allow to create a new product' do
      post products_path, params: { 
        product: { 
          title: 'Nintendo 64',
          description:'Le falta un control',
          price: 200,
          category_id: categories(:videogames).id
        }
      }
			assert_redirected_to products_path
      assert_equal flash[:notice], 'Product was successfully created'
    end

    test 'does not allow to create a new product whit empty fields' do
      post products_path, params: { 
        product: { 
          title: ' ',
          description:'Le falta un control',
          price: 200
        }
      }
			assert_response :unprocessable_entity
    end

    test 'allow to update a product' do
      patch product_path(products(:ps4)), params: { 
        product: { 
          price: 200
        }
      }
			assert_redirected_to products_path
      assert_equal flash[:notice], 'product was successfully updated.'
    end

    test 'does not allow to update a product' do
      patch product_path(products(:ps4)), params: { 
        product: { 
          price: nil
        }
      }
        assert_response :unprocessable_entity
    end

    test 'can delete product' do
      assert_difference('Product.count', -1) do
        delete product_path(products(:ps4))
      end

      assert_redirected_to products_path
      assert_equal flash[:notice], 'Product was deleted'
    end


end