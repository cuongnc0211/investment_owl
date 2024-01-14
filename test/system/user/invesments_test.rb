require "application_system_test_case"

class User::InvesmentsTest < ApplicationSystemTestCase
  setup do
    @user_invesment = user_invesments(:one)
  end

  test "visiting the index" do
    visit user_invesments_url
    assert_selector "h1", text: "Invesments"
  end

  test "should create invesment" do
    visit user_invesments_url
    click_on "New invesment"

    click_on "Create Invesment"

    assert_text "Invesment was successfully created"
    click_on "Back"
  end

  test "should update Invesment" do
    visit user_invesment_url(@user_invesment)
    click_on "Edit this invesment", match: :first

    click_on "Update Invesment"

    assert_text "Invesment was successfully updated"
    click_on "Back"
  end

  test "should destroy Invesment" do
    visit user_invesment_url(@user_invesment)
    click_on "Destroy this invesment", match: :first

    assert_text "Invesment was successfully destroyed"
  end
end
