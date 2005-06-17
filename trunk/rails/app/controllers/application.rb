# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
require_dependency "login_system"
require_dependency "wavedb_utils"
require_dependency "phonenum"
require_dependency "volunteer"
require_dependency "supply"
require_dependency "user"
require_dependency "disease"
require_dependency "notifier"
require_dependency "approx"
require_dependency "person"
require_dependency "location"
require_dependency "phonenum"

class ApplicationController < ActionController::Base
  include LoginSystem
  include WaveDBUtils
end
