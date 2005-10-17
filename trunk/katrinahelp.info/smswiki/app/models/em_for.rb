class EmFor < ActionMailer::Base
def forward( user, w )
  # Email header info MUST be added here
  @recipients = user.email
  @from = "smswiki@asiaquake.org"
  @subject = w.subj

  # Email body substitutions go here
#  @body["first_name"] = user.first_name
#  @body["last_name"] = user.last_name
  @body["body"] = w.body
end
end
