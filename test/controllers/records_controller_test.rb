require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  setup do
    @work = records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:works)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work" do
    assert_difference('Work.count') do
      post :create, work: { belongs_to: @work.belongs_to, original: @work.original, parsed: @work.parsed }
    end

    assert_redirected_to record_path(assigns(:work))
  end

  test "should show work" do
    get :show, id: @work
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work
    assert_response :success
  end

  test "should update work" do
    patch :update, id: @work, work: { belongs_to: @work.belongs_to, original: @work.original, parsed: @work.parsed }
    assert_redirected_to record_path(assigns(:work))
  end

  test "should destroy work" do
    assert_difference('Work.count', -1) do
      delete :destroy, id: @work
    end

    assert_redirected_to records_path
  end
end
