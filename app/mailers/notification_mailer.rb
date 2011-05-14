class NotificationMailer < ActionMailer::Base
  helper :application
  default :from => "from@example.com"
  default_url_options[:host] = APP_CONFIG['host']

  def mention_mail(mention)
    @mention = mention
    I18n.locale = mention.user.locale || I18n.default_locale
    mail(:to      => mention.user.email,
         :subject => I18n.t('notification_mailer.mention_mail.title'))
  end
end
