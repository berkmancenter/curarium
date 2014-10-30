require 'test_helper'

class SpotlightsControllerTest < ActionController::TestCase
  setup do
    @spotlight = spotlights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spotlights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spotlight" do
    assert_difference('Spotlight.count') do
      post :create, spotlight: { body: @spotlight.body, records: @spotlight.works, title: @spotlight.title, type: @spotlight.type }
    end

    assert_redirected_to spotlight_path(assigns(:spotlight))
  end

  test "should show spotlight" do
    get :show, id: @spotlight
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spotlight
    assert_response :success
  end

  test "should update spotlight" do
    patch :update, id: @spotlight, spotlight: { body: @spotlight.body, records: @spotlight.works, title: @spotlight.title, type: @spotlight.type }
    assert_redirected_to spotlight_path(assigns(:spotlight))
  end

  test "should destroy spotlight" do
    assert_difference('Spotlight.count', -1) do
      delete :destroy, id: @spotlight
    end

    assert_redirected_to spotlights_path
  end
end
