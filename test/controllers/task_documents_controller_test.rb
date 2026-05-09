require "test_helper"

class TaskDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get task_documents_index_url
    assert_response :success
  end

  test "should get show" do
    get task_documents_show_url
    assert_response :success
  end

  test "should get new" do
    get task_documents_new_url
    assert_response :success
  end

  test "should get edit" do
    get task_documents_edit_url
    assert_response :success
  end

  test "should get create" do
    get task_documents_create_url
    assert_response :success
  end

  test "should get update" do
    get task_documents_update_url
    assert_response :success
  end

  test "should get destroy" do
    get task_documents_destroy_url
    assert_response :success
  end
end
