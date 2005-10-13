class Notifier < ActionMailer::Base
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.server_settings[:address] = '80.69.76.16'
  def status_changed(login, email, petid, petname)
    @sent_on = Time.new
    @body['login'] = login
    @body['petname'] = petname
    @body['petid'] = petid
    @body['sent_on'] = @sent_on
    @recipients = email
    @subject = "Status changed for #{petname}"
    @from = "webuser@asiaquake.org"
  end
end
