Factory.define :user do |user|
  user.sequence(:username) {|n| "user_#{n}"}
  user.sequence(:email) {|n| "user#{n}@local.me"}
  user.password 'password'
  user.password_confirmation 'password'
end

Factory.define :topic do |topic|
  topic.title 'title'
  topic.content 'content'
  topic.association :user
end

Factory.define :reply do |reply|
  reply.content 'content'
  reply.association :user
  reply.association :topic
end

Factory.define :notification_mention, :class => Notification::Mention do |mention|
  mention.association :user
  mention.association :topic
  mention.association :reply_user, :factory => :user
  mention.association :reply
  mention.text 'message'
end
