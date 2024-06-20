ENV["RAILS_ENV"] ||= "test"
# Consider setting MT_NO_EXPECTATIONS to not add expectations to Object.
# ENV["MT_NO_EXPECTATIONS"] = "true"
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

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end

class ActionController::TestCase
  include FactoryBot::Syntax::Methods
end


# ======================
# Minitest configuration
# ======================

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new


# ========================
# Database cleaner configs
# ========================

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end


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
