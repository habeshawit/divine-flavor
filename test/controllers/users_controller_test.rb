require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get my_recipes" do
    get users_my_recipes_url
    assert_response :success
  end

end
