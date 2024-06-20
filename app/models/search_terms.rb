class SearchTerms
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :terms

  # The SearchTerms can be initialized with either:
  #    1. A hash with the key :term_string, eg {term_string: 'lime'}
  #    2. An array of strings, eg ['lime', 'rum']
  #    3. A comma-separated string, eg 'lime, rum'
  def initialize(search_terms = '')
    @terms = []

    if search_terms.is_a?(Hash) && search_terms.symbolize_keys! && search_terms[:term_string]
      self.term_string = search_terms[:term_string]
    elsif search_terms.respond_to?(:map)
      self.term_string = search_terms.map(&:to_s).join(', ')
    elsif search_terms.is_a?(String)
      self.term_string = search_terms
    elsif search_terms.present?
      raise ArgumentError, "The terms param must be an array, a hash of the form {term_string: 'term1, term2'}, or a comma-separated String, instead of a #{term_string.class}"
    end
  end

  def term_string
    @terms.collect(&:to_s).join(", ")
  end

  def term_string=(new_value)
    @terms = if new_value.respond_to?(:split)
      new_value.split(',').map{|term| SearchTerm.new(term.strip) }
    else
      []
    end
  end

  def scope
    keywords = {positive: [], negative: []}
    @terms.each do |term|
      term.positive? ? keywords[:positive] << term : keywords[:negative] << term
    end
    Cocktail.with_and_without_keywords(keywords)
  end

  def method_missing(method, *args)
    if @terms.respond_to?(method)
      define_method method do |*arguments|
        @terms.send(method, *arguments)
      end
      send(method, *args)
    end
  end

  # This is required to make one of the ActiveModel mixins work
  def persisted?
    false
  end
end