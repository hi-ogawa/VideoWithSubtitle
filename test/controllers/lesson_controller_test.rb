require 'test_helper'

class LessonControllerTest < ActionController::TestCase
  test "should get scripts" do
    get :scripts
    assert_response :success
  end

end
