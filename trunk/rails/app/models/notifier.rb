require 'action_mailer'

class Notifier < ActionMailer::Base
  #ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.server_settings[:address] = '80.69.76.16'
  def request_help(login, name, email, volname, volemail, subject, bodytxt)
    @body['login'] = login
    @body['subject'] = subject
    @body['name'] = name
    @body['volname'] = volname
    @body['bodytxt'] = bodytxt
    @recipients = volemail
    @subject = "ASIAQUAKE HELP REQ: #{subject}"
    @from = email
    @sent_on = Time.new
  end
  def status_changed_person(login, email, personid, personname)
    @body['login'] = login
    @body['personname'] = personname
    @body['personid'] = personid
    @recipients = email
    @subject = "Status changed for #{personname}"
    @from = "webuser@asiaquake.org"
    @sent_on = Time.new
  end
  def verify_email(login, email, pvt)
    @body['pvt'] = pvt
    @body['login'] = login
    @body['email'] = email
    @recipients = email
    @subject = "Welcome to AsiaQuake.org!"
    @from = "webuser@asiaquake.org"
    @sent_on = Time.new
  end
end
