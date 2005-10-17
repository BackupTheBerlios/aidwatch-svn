class Notifier < ActionMailer::Base
    def receive(email)
      w = WikiMessage.new(:mar => Marshal.dump(email), :subj => email.subject, :body => email.body)
      w.save
#      File.open('/tmp/ssgs.txt', 'a') { |f|
#        f.puts ("To: #{email.to.first}")
#        f.puts ("Subject: #{email.subject}")
#        f.puts ("Body: #{email.body}")
#      }
    end

end
