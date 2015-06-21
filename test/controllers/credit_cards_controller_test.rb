require 'test_helper'

class CreditCardsControllerTest < ActionController::TestCase
  setup do
    @credit_card = credit_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:credit_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create credit_card" do
    assert_difference('CreditCard.count') do
      post :create, credit_card: { bank: @credit_card.bank, bin: @credit_card.bin, brand: @credit_card.brand, card_holder: @credit_card.card_holder, card_number: @credit_card.card_number, card_type: @credit_card.card_type, city: @credit_card.city, country_code: @credit_card.country_code, country_name: @credit_card.country_name, cvv: @credit_card.cvv, expiry: @credit_card.expiry, state: @credit_card.state, zip: @credit_card.zip }
    end

    assert_redirected_to credit_card_path(assigns(:credit_card))
  end

  test "should show credit_card" do
    get :show, id: @credit_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @credit_card
    assert_response :success
  end

  test "should update credit_card" do
    patch :update, id: @credit_card, credit_card: { bank: @credit_card.bank, bin: @credit_card.bin, brand: @credit_card.brand, card_holder: @credit_card.card_holder, card_number: @credit_card.card_number, card_type: @credit_card.card_type, city: @credit_card.city, country_code: @credit_card.country_code, country_name: @credit_card.country_name, cvv: @credit_card.cvv, expiry: @credit_card.expiry, state: @credit_card.state, zip: @credit_card.zip }
    assert_redirected_to credit_card_path(assigns(:credit_card))
  end

  test "should destroy credit_card" do
    assert_difference('CreditCard.count', -1) do
      delete :destroy, id: @credit_card
    end

    assert_redirected_to credit_cards_path
  end
end
