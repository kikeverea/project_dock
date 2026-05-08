require "test_helper"

class InteractionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interaction = interactions(:one)
  end

  test "should get index" do
    get interactions_url
    assert_response :success
  end

  test "should get new" do
    get new_interaction_url
    assert_response :success
  end

  test "should create interaction" do
    assert_difference("TaskComment.count") do
      post interactions_url, params: { interaction: { activity_id: @interaction.activity_id, content: @interaction.content, status: @interaction.status, user_id: @interaction.user_id } }
    end

    assert_redirected_to interaction_url(TaskComment.last)
  end

  test "should show interaction" do
    get interaction_url(@interaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_interaction_url(@interaction)
    assert_response :success
  end

  test "should update interaction" do
    patch interaction_url(@interaction), params: { interaction: { activity_id: @interaction.activity_id, content: @interaction.content, status: @interaction.status, user_id: @interaction.user_id } }
    assert_redirected_to interaction_url(@interaction)
  end

  test "should destroy interaction" do
    assert_difference("TaskComment.count", -1) do
      delete interaction_url(@interaction)
    end

    assert_redirected_to interactions_url
  end
end
