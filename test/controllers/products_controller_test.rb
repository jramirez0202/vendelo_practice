require 'test_helper'
class ProductControllerTest < ActionDispatch::IntegrationTest
    test 'render list of products' do
        get products_path

        assert_response :success
        assert_select '.product', 2
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
          price: 200
        }
      }
			assert_redirected_to products_path
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


end