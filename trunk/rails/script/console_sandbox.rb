#!/home/webuser/mySoftware/ruby-1.8.2/bin/ruby
ActiveRecord::Base.lock_mutex
ActiveRecord::Base.connection.begin_db_transaction
at_exit do
  ActiveRecord::Base.connection.rollback_db_transaction
  ActiveRecord::Base.unlock_mutex
end
