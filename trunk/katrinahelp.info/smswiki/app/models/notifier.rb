class Notifier < ActionMailer::Base
    def receive(email)
      w = WikiMessage.new(:mar => Marshal.dump(email), :subj => email.subject, :body => email.body)
      w.save
      f = EmailForward.find_all
      f.each { |g|
        EmFor::forward(g,w)
      }
    end

end
