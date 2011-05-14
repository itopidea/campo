class Reply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  has_and_belongs_to_many :mention_users, :class_name => 'User', :validate => false
  belongs_to :topic
  belongs_to :user

  validates_presence_of :content

  attr_accessible :content

  after_create :increment_topic_reply_cache, :add_replier_ids
  after_destroy :decrement_topic_reply_cache
  after_create :async_send_mention_notification

  def async_send_mention_notification
    Resque.enqueue(Resque::MentionJob, self.id)
  end

  def increment_topic_reply_cache
    topic.last_replied_by = user
    topic.actived_at = created_at
    topic.save
    topic.inc :replies_count, 1
  end

  def decrement_topic_reply_cache
    # ignore user and time cache
    topic.inc :replies_count, -1
  end

  def add_replier_ids
    topic.reply_by self.user
  end

  MentionRegex = /@(\w{3,20})(?![.\w])/
  def extract_mentions
    usernames = self.content.to_s.scan(MentionRegex).flatten.uniq.delete_if{|username| username == self.user.username}.slice(0..4)
    if usernames.blank?
      self.mention_user_ids = []
    else
      self.mention_user_ids = User.where(:username.in => usernames.map{|username| /^#{username}$/i }).only(:_id).map(&:_id)
    end
    save
  end

  def send_mention_notifications
    extract_mentions
    mention_users.each do |user|
      if user.email_mention?
        user.send_notification({:reply_user_id  => self.user_id,
                                :topic_id => self.topic_id,
                                :reply_id => self.id,
                                :text     => self.content.slice(0..99)}, Notification::Mention)
      end
    end
  end
end
