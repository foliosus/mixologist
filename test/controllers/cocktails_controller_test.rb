require 'test_helper'

class CocktailsControllerTest < ActionController::TestCase
  setup do
    @cocktail = build(:cocktail)
  end

  should "get new" do
    get :new
    assert_response :success
  end

  should "create cocktail" do
    assert_difference('Cocktail.count') do
      post :create, params: { cocktail: @cocktail.attributes }
    end

    assert_redirected_to cocktail_path(assigns(:cocktail))
    assigns(:cocktail).destroy
  end

  context "with an existing cocktail" do
    setup do
      @cocktail = create(:cocktail)
    end
    teardown do
      @cocktail.destroy
    end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:cocktails)
    end

    should "show cocktail" do
      get :show, params: { id: @cocktail.to_param }
      assert_response :success
    end

    should "get edit" do
      get :edit, params: { id: @cocktail.to_param }
      assert_response :success
    end

    should "update cocktail" do
      put :update, params: { id: @cocktail.to_param, cocktail: @cocktail.attributes }
      assert_redirected_to cocktail_path(@cocktail)
    end

    should "destroy cocktail" do
      assert_difference('Cocktail.count', -1) do
        delete :destroy, params: { id: @cocktail.to_param }
      end

      assert_redirected_to cocktails_path
    end
  end

  context "without a cocktail" do
    should "redirect to new from index" do
      Cocktail.delete_all
      get :index
      assert_redirected_to new_cocktail_path, @response.body
    end
  end
end
