class Resque::MentionJob
  @queue = :mention

  def self.perform(reply_id)
    reply = Reply.find reply_id
    reply.send_mention_notifications
  end
end
