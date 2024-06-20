require 'test_helper'

class GarnishTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:cocktails)
  should validate_presence_of(:name)
end
