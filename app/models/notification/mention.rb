class Notification::Mention < Notification::Base
  belongs_to :topic
  belongs_to :reply
  belongs_to :reply_user, :class_name => 'User'

  after_create :send_mail_notification

  def send_mail_notification
    NotificationMailer.mention_mail(self).deliver
  end
end
