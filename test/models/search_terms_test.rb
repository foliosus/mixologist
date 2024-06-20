require 'test_helper'

class SearchTermsTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  setup do
    # This makes the ActiveModel::Lint::Tests go
    @model = SearchTerms.new
  end

  context "a SearchTerm" do
    setup do
      @terms = %w(foo bar baz)
      @terms.map!{|term| SearchTerm.new(term) }
      @search_terms = SearchTerms.new(@terms)
    end

    should "take new search terms on init" do
      assert_equal @terms, @search_terms.terms, "Should have the right terms"
    end

    context "with new terms" do
      setup do
        @new_terms = %w(fubar bazic)
        @new_terms.map!{|term| SearchTerm.new(term) }
      end

      should "take a new set of search terms" do
        @search_terms.terms = @new_terms
        assert_equal @new_terms, @search_terms.terms, "Should have taken the assignment"
      end

      should "take a new search string" do
        @search_terms.term_string = @new_terms.join(', ')
        assert_equal @new_terms, @search_terms.terms, "Should have taken the assignment, and done the array spliting and cleaning up"
      end
    end
  end
end
