require "application_system_test_case"

class TaskCategoriesTest < ApplicationSystemTestCase
  setup do
    @task_category = task_categories(:one)
  end

  test "visiting the index" do
    visit task_categories_url
    assert_selector "h1", text: "Task categories"
  end

  test "should create task category" do
    visit task_categories_url
    click_on "New task category"

    fill_in "Color", with: @task_category.color
    fill_in "Name", with: @task_category.name
    click_on "Create Task category"

    assert_text "Task category was successfully created"
    click_on "Back"
  end

  test "should update Task category" do
    visit task_category_url(@task_category)
    click_on "Edit this task category", match: :first

    fill_in "Color", with: @task_category.color
    fill_in "Name", with: @task_category.name
    click_on "Update Task category"

    assert_text "Task category was successfully updated"
    click_on "Back"
  end

  test "should destroy Task category" do
    visit task_category_url(@task_category)
    click_on "Destroy this task category", match: :first

    assert_text "Task category was successfully destroyed"
  end
end
