class SearchTerm
  include Comparable

  attr_reader :term

  def initialize(term)
    @negative = term.starts_with?('-')
    @term = @negative ? term[1..-1] : term
  end

  def to_s
    negative? ? "-#{@term}" : @term
  end

  def negative?
    @negative
  end

  def positive?
    !negative?
  end

  def <=>(other)
    if other.is_a?(SearchTerm)
      if negative? == other.negative?
        to_s <=> other.to_s
      else
        negative? ? -1 : 1
      end
    else
      to_s <=> other
    end
  end

  protected def method_missing(method, *args)
    if @term.respond_to?(method)
      @term.send(method, *args)
    else
      super
    end
  end
end
