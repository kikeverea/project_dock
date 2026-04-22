require "application_system_test_case"

class BillingMethodsTest < ApplicationSystemTestCase
  setup do
    @billing_method = billing_methods(:one)
  end

  test "visiting the index" do
    visit billing_methods_url
    assert_selector "h1", text: "Billing methods"
  end

  test "should create billing method" do
    visit billing_methods_url
    click_on "New billing method"

    fill_in "Name", with: @billing_method.name
    click_on "Create Billing method"

    assert_text "Billing method was successfully created"
    click_on "Back"
  end

  test "should update Billing method" do
    visit billing_method_url(@billing_method)
    click_on "Edit this billing method", match: :first

    fill_in "Name", with: @billing_method.name
    click_on "Update Billing method"

    assert_text "Billing method was successfully updated"
    click_on "Back"
  end

  test "should destroy Billing method" do
    visit billing_method_url(@billing_method)
    click_on "Destroy this billing method", match: :first

    assert_text "Billing method was successfully destroyed"
  end
end
