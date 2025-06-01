require "simplecov"

SimpleCov.start "rails" do
  use_merging true
  merge_timeout 3600
  enable_coverage :branch
  add_filter "/test/"
  add_filter "/config/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "helpers/sign_in_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}[#{worker}]"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end


class ActionDispatch::IntegrationTest
  include SignInHelper
end
