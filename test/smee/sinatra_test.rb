require "test_helper"

class Smee::SinatraTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Smee::Sinatra::VERSION
  end

  def test_it_does_something_useful
    assert :lol
  end
end
