require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @request = requests(:one)
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should get new" do
    get new_request_url
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      post requests_url, params: { request: { author_email: @request.author_email, author_name: @request.author_name, cookie: @request.cookie, end_date: @request.end_date, query: @request.query, source_type: @request.source_type, start_date: @request.start_date, status: @request.status } }
    end

    assert_redirected_to request_url(Request.last)
  end

  test "should show request" do
    get request_url(@request)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_url(@request)
    assert_response :success
  end

  test "should update request" do
    patch request_url(@request), params: { request: { author_email: @request.author_email, author_name: @request.author_name, cookie: @request.cookie, end_date: @request.end_date, query: @request.query, source_type: @request.source_type, start_date: @request.start_date, status: @request.status } }
    assert_redirected_to request_url(@request)
  end

  test "should destroy request" do
    assert_difference('Request.count', -1) do
      delete request_url(@request)
    end

    assert_redirected_to requests_url
  end
end
