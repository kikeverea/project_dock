require "application_system_test_case"

class PhaseTasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Phase tasks"
  end

  test "should create phase task" do
    visit tasks_url
    click_on "New phase task"

    fill_in "Estimated days", with: @task.expires_at
    fill_in "Name", with: @task.name
    fill_in "Order", with: @task.order
    fill_in "Phase", with: @task.phase_id
    click_on "Create Phase task"

    assert_text "Phase task was successfully created"
    click_on "Back"
  end

  test "should update Phase task" do
    visit task_url(@task)
    click_on "Edit this phase task", match: :first

    fill_in "Estimated days", with: @task.expires_at
    fill_in "Name", with: @task.name
    fill_in "Order", with: @task.order
    fill_in "Phase", with: @task.phase_id
    click_on "Update Phase task"

    assert_text "Phase task was successfully updated"
    click_on "Back"
  end

  test "should destroy Phase task" do
    visit task_url(@task)
    click_on "Destroy this phase task", match: :first

    assert_text "Phase task was successfully destroyed"
  end
end
