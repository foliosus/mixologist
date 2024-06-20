require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  context "with an ingredient" do
    setup do
      @ingredient = create(:ingredient)
    end
    teardown do
      @ingredient.destroy
    end

    should "get index" do
      get :index
      assert_response :success
      assert_select "table tbody tr", {count: 1}, "Should have one row per ingredient"
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create ingredient" do
      attribs = attributes_for(:ingredient)
      attribs[:ingredient_category_id] = attribs.delete(:ingredient_category).id
      assert_difference('Ingredient.count') do
        post :create, params: { ingredient: attribs }
      end

      assert_redirected_to ingredients_path
    end

    should "get edit" do
      get :edit, params: { id: @ingredient.to_param }
      assert_response :success
    end

    should "update ingredient" do
      put :update, params: { id: @ingredient.to_param, ingredient: {name: 'new name'} }
      assert_redirected_to ingredients_path
      @ingredient.reload
      assert_equal 'new name', @ingredient.name
    end

    should "destroy ingredient" do
      assert_difference('Ingredient.count', -1) do
        delete :destroy, params: { id: @ingredient.to_param }
      end

      assert_redirected_to ingredients_path
    end
  end

  context "without an ingredient" do
    should "redirect to new page on index" do
      get :index
      assert_redirected_to new_ingredient_path
    end
  end
end
