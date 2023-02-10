require 'test_helper'
class ProductControllerTest < ActionDispatch::IntegrationTest
    test 'render list of products in index' do
        get products_path

        assert_response :success
        assert_select '.product', 3
        assert_select '.category', 3
    end

    test 'render a list of products filtered by category' do
      get products_path(category_id: categories(:computers).id)

      assert_response :success
      assert_select '.product', 1

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