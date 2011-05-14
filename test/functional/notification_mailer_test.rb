require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "should send mention mail" do
    mention = Factory.build :notification_mention
    email = NotificationMailer.mention_mail(mention).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [mention.user.email], email.to
    assert_equal I18n.t('notification_mailer.mention_mail.title'), email.subject
  end
end
