require 'test_helper'

class Notification::MentionTest < ActiveSupport::TestCase
  test "should send email" do
    mention = Factory :notification_mention
    assert !ActionMailer::Base.deliveries.empty?
  end
end
