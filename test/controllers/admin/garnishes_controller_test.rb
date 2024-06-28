require 'test_helper'

class Admin::GarnishesControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_garnishes_path
      assert_response :not_found
    end
  end

  context "when logged in with a garnish" do
    setup do
      @garnish = create(:garnish)
      @user = create(:user)
      login(@user, password: @user.password)
    end

    should "get index" do
      get admin_garnishes_path
      assert_response :success
      assert_select "table tbody tr", {count: Garnish.count}, "Should have one row per ingredient"
    end

    should "get new" do
      get new_admin_garnish_path
      assert_response :success
    end

    should "create garnish" do
      assert_difference('Garnish.count') do
        post admin_garnishes_path, params: { garnish: attributes_for(:garnish) }
      end

      assert_redirected_to admin_garnishes_path
    end

    should "get edit" do
      get edit_admin_garnish_path(@garnish)
      assert_response :success
    end

    should "update garnish" do
      patch admin_garnish_path(@garnish), params: { garnish: attributes_for(:garnish) }
      assert_redirected_to admin_garnishes_path
    end

    should "destroy garnish" do
      assert_difference('Garnish.count', -1) do
        delete admin_garnish_path(@garnish)
      end

      assert_redirected_to admin_garnishes_path
    end
  end
end