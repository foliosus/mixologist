require 'test_helper'

class Admin::CocktailsControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_cocktails_path
      assert_response :not_found
    end
  end

  context "when logged in with a cocktail" do
    setup do
      @cocktail = create(:cocktail)
      @user = create(:user)
      login(@user, password: @user.password)
    end
    teardown do
      @cocktail.destroy
      @user.destroy
    end

    should "get index" do
      get admin_cocktails_path
      assert_response :success
      assert_select ".cocktails cocktail", {count: Cocktail.count}, "Should have one card per cocktail"
    end

    should "show cocktail" do
      get admin_cocktail_path(@cocktail)
      assert_response :success
    end

    should "get new" do
      get new_admin_cocktail_path
      assert_response :success
    end

    should "create cocktail" do
      assert_difference('Cocktail.count') do
        post admin_cocktails_path, params: { cocktail: attributes_for(:cocktail) }
      end

      assert_redirected_to admin_cocktail_path(Cocktail.last)
    end

    should "get edit" do
      get edit_admin_cocktail_path(@cocktail)
      assert_response :success
    end

    should "update cocktail" do
      patch admin_cocktail_path(@cocktail), params: { cocktail: {name: "new name"} }
      assert_redirected_to admin_cocktail_path(@cocktail)
      @cocktail.reload
      assert_equal "new name", @cocktail.name
    end

    should "destroy cocktail" do
      assert_difference('Cocktail.count', -1) do
        delete admin_cocktail_path(@cocktail)
      end

      assert_redirected_to admin_cocktails_path
    end
  end
end