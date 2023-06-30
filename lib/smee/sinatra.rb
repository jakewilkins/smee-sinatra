# frozen_string_literal: true

require "smee/sinatra/version"
require "smee/sinatra/runner"

module Smee
  module Sinatra
    class Error < StandardError; end

    if Smee::Sinatra::Runner.should_run?
      Smee::Sinatra::Runner.start
    end
  end
end
