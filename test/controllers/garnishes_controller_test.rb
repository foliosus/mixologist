require 'test_helper'

class GarnishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @garnish = create(:garnish)
  end
  teardown do
    @garnish.destroy
  end

  test "should get index" do
    get garnishes_url
    assert_response :success
  end

  test "should get new" do
    get new_garnish_url
    assert_response :success
  end

  test "should create garnish" do
    assert_difference('Garnish.count') do
      post garnishes_url, params: { garnish: attributes_for(:garnish) }
    end

    assert_redirected_to garnishes_url
  end

  test "should get edit" do
    get edit_garnish_url(@garnish)
    assert_response :success
  end

  test "should update garnish" do
    patch garnish_url(@garnish), params: { garnish: attributes_for(:garnish) }
    assert_redirected_to garnishes_url
  end

  test "should destroy garnish" do
    assert_difference('Garnish.count', -1) do
      delete garnish_url(@garnish)
    end

    assert_redirected_to garnishes_url
  end
end
