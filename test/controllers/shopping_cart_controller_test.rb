require 'test_helper'

class ShoppingCartControllerTest < ActionController::TestCase
  test "should get add_to_cart" do
    get :add_to_cart
    assert_response :success
  end

  test "should get remove_from_cart" do
    get :remove_from_cart
    assert_response :success
  end

end
