ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require_relative 'random_id'
require_relative 'fixture_setup'

class ActiveSupport::TestCase
  def assert_deleted(record, message = 'deleted')
    assert_raises(ActiveRecord::RecordNotFound, message) do
      record.reload
    end
  end

  def assert_no_queries(message = nil, &block)
    fail_on_query = lambda do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      ActiveSupport::Notifications.unsubscribe('sql.active_record')
      message &&= "#{message}\n"
      flunk("No queries should be made\n#{message}#{event.payload[:sql]}")
    end

    ActiveSupport::Notifications.subscribed(fail_on_query, 'sql.active_record', &block)
  end

  # Add more helper methods to be used by all tests here...
end

ApplicationRecord.include(RandomId)

require 'mocha/minitest'
Minitest.load_plugins
Minitest::PrideIO.pride!

FixtureSetup.create_fixtures

# Allow use of `assert_equal` for comparing against `nil`
module Minitest::Assertions
  alias _assert_equal assert_equal
  def assert_equal(exp, act, msg = nil)
    if exp.nil?
      assert_nil(act, msg)
    else
      _assert_equal(exp, act, msg)
    end
  end
end
