require 'rails_generator'

class LoginGenerator < Rails::Generator::Base
  def generate
    
    # Model class, unit test, and fixtures.
    template "controller.rb", "app/controllers/#{file_name}_controller.rb"
    template "controller_test.rb", "test/functional/#{file_name}_controller_test.rb"
    template "helper.rb", "app/helpers/#{file_name}_helper.rb"
    template "login_system.rb", "lib/login_system.rb"
    template "user.rb", "app/models/user.rb"
    template "user_test.rb", "test/unit/user_test.rb"
    template "users.yml", "test/fixtures/users.yml"
    template "user.sql", "db/user_model.sql"

    # Layout and stylesheet.
    unless File.file?("app/views/layouts/scaffold.rhtml")
      template "layout.rhtml", "app/views/layouts/scaffold.rhtml"
    end
    unless File.file?("public/stylesheets/scaffold.css")
      template "style.css", "public/stylesheets/scaffold.css"
    end

    #views 
    views.each do |action|
      template "view_#{action}.rhtml", "app/views/#{file_name}/#{action}.rhtml"
    end

    template "README", "README_LOGIN"
    
    puts File.open(File.dirname(__FILE__)+'/templates/README').read
    
  end
  
  protected
  
  def views
    ['welcome', 'login', 'logout', 'signup']
  end
end
