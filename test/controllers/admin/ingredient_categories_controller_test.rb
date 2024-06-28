require 'test_helper'

class Admin::IngredientCategoriesControllerTest < ActionDispatch::IntegrationTest
  context "when not logged in" do
    should "not get the index" do
      get admin_ingredient_categories_path
      assert_response :not_found
    end
  end

  context "when logged in with an ingredient category" do
    setup do
      @ingredient_category = create(:ingredient_category)
      @user = create(:user)
      login(@user, password: @user.password)
    end

    should "get index" do
      get admin_ingredient_categories_path
      assert_response :success
      assert_select "table tbody tr", {count: IngredientCategory.count}, "Should have one row per ingredient category"
    end

    should "get new" do
      get new_admin_ingredient_category_path
      assert_response :success
    end

    should "create ingredient_category" do
      assert_difference('IngredientCategory.count') do
        post admin_ingredient_categories_path, params: { ingredient_category: attributes_for(:ingredient_category) }
      end

      assert_redirected_to admin_ingredient_categories_path
    end

    should "get edit" do
      get edit_admin_ingredient_category_path(@ingredient_category)
      assert_response :success
    end

    should "update ingredient_category" do
      patch admin_ingredient_category_path(@ingredient_category), params: { ingredient_category: {name: "new name"} }
      assert_redirected_to admin_ingredient_categories_path
      @ingredient_category.reload
      assert_equal "new name", @ingredient_category.name
    end

    should "destroy ingredient_category" do
      assert_difference('IngredientCategory.count', -1) do
        delete admin_ingredient_category_path(@ingredient_category)
      end

      assert_redirected_to admin_ingredient_categories_path
    end
  end
end
