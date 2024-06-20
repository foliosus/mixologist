require 'test_helper'

class SearchTermTest < ActiveSupport::TestCase
  context "a search term" do
    setup do
      @term = SearchTerm.new('lime')
    end

    should "have a to_s that returns the term" do
      assert_equal @term.term, @term.to_s
    end

    should "recognize when it's not a negative search" do
      refute @term.negative?, "Since the term doesn't start with a minus sign, it's positive"
    end

    should "be equal to an equivalent positive term" do
      assert_equal @term, SearchTerm.new(@term.to_s)
    end

    should "not be equal to an equivalent negative term" do
      refute_equal @term, SearchTerm.new("-#{@term}")
    end
  end

  context "a negative search term" do
    setup do
      @term = SearchTerm.new('-lime')
    end

    should "have a to_s that returns the term, with the leading minus" do
      assert_equal '-lime', @term.to_s
    end

    should "recognize when it's not a negative search" do
      assert @term.negative?, "Since the term starts with a minus sign, it's negative"
    end

    should "not be equal to an equivalent positive term" do
      refute_equal @term, SearchTerm.new(@term[1..-1])
    end

    should "be equal to an equivalent negative term" do
      assert_equal @term, SearchTerm.new("-lime")
    end
  end
end
