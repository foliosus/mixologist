ENV["RAILS_ENV"] ||= "test"
ENV["MT_NO_EXPECTATIONS"] = "true" # Do not add expectation to Object
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"
require "database_cleaner/active_record"

# ==================
# Test class patches
# ==================

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    include ::DatabaseCleaning

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end

class ActionController::TestCase
  include FactoryBot::Syntax::Methods
  include ::DatabaseCleaning
end

class ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods
  include ReviseAuth::Test::Helpers
  include ::DatabaseCleaning
end


# ======================
# Minitest configuration
# ======================

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)


# ========================
# Database cleaner configs
# ========================

DatabaseCleaner.strategy = :transaction


# ===============
# Shoulda configs
# ===============

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

# Shoulda matchers' methods like validates_numericality_of calls the old errors.keys syntax, which was deprecated in
# favor of errors.attribute_names. This sets up an alias so that the matchers work.
class ActiveModel::Errors
  def keys
    attribute_names
  end
end
