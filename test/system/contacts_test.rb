require "application_system_test_case"

class ContactsTest < ApplicationSystemTestCase
  setup do
    @contact = contacts(:one)
  end

  test "visiting the index" do
    visit contacts_url
    assert_selector "h1", text: "Contacts"
  end

  test "should create contact" do
    visit contacts_url
    click_on "New contact"

    fill_in "Address", with: @contact.address
    fill_in "Birthdate", with: @contact.birthdate
    fill_in "City", with: @contact.city
    fill_in "Lastname", with: @contact.lastname
    fill_in "Lastname2", with: @contact.lastname2
    fill_in "Name", with: @contact.name
    fill_in "Nif", with: @contact.nif
    fill_in "Observations", with: @contact.observations
    fill_in "Origin", with: @contact.origin
    fill_in "Postcode", with: @contact.postcode
    fill_in "Type", with: @contact.type
    click_on "Create Contact"

    assert_text "Contact was successfully created"
    click_on "Back"
  end

  test "should update Contact" do
    visit contact_url(@contact)
    click_on "Edit this contact", match: :first

    fill_in "Address", with: @contact.address
    fill_in "Birthdate", with: @contact.birthdate
    fill_in "City", with: @contact.city
    fill_in "Lastname", with: @contact.lastname
    fill_in "Lastname2", with: @contact.lastname2
    fill_in "Name", with: @contact.name
    fill_in "Nif", with: @contact.nif
    fill_in "Observations", with: @contact.observations
    fill_in "Origin", with: @contact.origin
    fill_in "Postcode", with: @contact.postcode
    fill_in "Type", with: @contact.type
    click_on "Update Contact"

    assert_text "Contact was successfully updated"
    click_on "Back"
  end

  test "should destroy Contact" do
    visit contact_url(@contact)
    click_on "Destroy this contact", match: :first

    assert_text "Contact was successfully destroyed"
  end
end
