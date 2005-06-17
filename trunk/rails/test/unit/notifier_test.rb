require File.dirname(__FILE__) + '/../test_helper'
require 'notifier'

class NotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
  end

  def test_truth
    assert true
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/notifier/#{action}")
    end
end
