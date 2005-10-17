require File.dirname(__FILE__) + '/../test_helper'

class WikiMessageTest < Test::Unit::TestCase
  fixtures :wiki_messages

  def setup
    @wiki_message = WikiMessage.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of WikiMessage,  @wiki_message
  end
end
