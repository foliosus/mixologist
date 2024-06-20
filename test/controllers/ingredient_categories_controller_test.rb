require 'test_helper'

class IngredientCategoriesControllerTest < ActionController::TestCase
  context "with a category" do
    setup do
      @ingredient_category = create(:ingredient_category)
    end
    teardown do
      @ingredient_category.destroy
    end

    should "get index" do
      get :index
      assert_response :success
      assert_select "table tbody tr", {count: 1}, "Should have one row per ingredient category"
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create ingredient_category" do
      assert_difference('IngredientCategory.count') do
        post :create, params: { ingredient_category: attributes_for(:ingredient_category) }
      end

      assert_redirected_to ingredient_categories_path
    end

    should "get edit" do
      get :edit, params: { id: @ingredient_category }
      assert_response :success
    end

    should "update ingredient_category" do
      patch :update, params: { id: @ingredient_category, ingredient_category: attributes_for(:ingredient_category) }
      assert_redirected_to ingredient_categories_path
    end

    should "destroy ingredient_category" do
      assert_difference('IngredientCategory.count', -1) do
        delete :destroy, params: { id: @ingredient_category }
      end

      assert_redirected_to ingredient_categories_path
    end
  end
end
