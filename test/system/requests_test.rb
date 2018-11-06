require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
  setup do
    @request = requests(:one)
  end

  test "visiting the index" do
    visit requests_url
    assert_selector "h1", text: "Requests"
  end

  test "creating a Request" do
    visit requests_url
    click_on "New Request"

    fill_in "Author Email", with: @request.author_email
    fill_in "Author Name", with: @request.author_name
    fill_in "Cookie", with: @request.cookie
    fill_in "End Date", with: @request.end_date
    fill_in "Query", with: @request.query
    fill_in "Source Type", with: @request.source_type
    fill_in "Start Date", with: @request.start_date
    fill_in "Status", with: @request.status
    click_on "Create Request"

    assert_text "Request was successfully created"
    click_on "Back"
  end

  test "updating a Request" do
    visit requests_url
    click_on "Edit", match: :first

    fill_in "Author Email", with: @request.author_email
    fill_in "Author Name", with: @request.author_name
    fill_in "Cookie", with: @request.cookie
    fill_in "End Date", with: @request.end_date
    fill_in "Query", with: @request.query
    fill_in "Source Type", with: @request.source_type
    fill_in "Start Date", with: @request.start_date
    fill_in "Status", with: @request.status
    click_on "Update Request"

    assert_text "Request was successfully updated"
    click_on "Back"
  end

  test "destroying a Request" do
    visit requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Request was successfully destroyed"
  end
end
