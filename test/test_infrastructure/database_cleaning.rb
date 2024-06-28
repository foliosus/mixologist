# require 'active_support/concern'

module DatabaseCleaning
  extend ActiveSupport::Concern

  included do
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end
  end
end
