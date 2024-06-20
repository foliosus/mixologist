class RecipeItemParser
  def initialize(str, options = {})
    @str = str
    @options = options
  end

  def parse!
    number_indicators = ('0'..'9').to_a + ['.']
    amount = 0
    while parts.first.first.in?(number_indicators)
      amount_token = parts.shift
      amount += string_to_number(amount_token)
    end
    amount = nil if amount == 0

    unit = if Unit.named(parts.first).exists?
      Unit.named(parts.shift).first
    else
      nil
    end

    parts.shift if parts.first.downcase == 'of'

    ingredient = Ingredient.named(parts.join(' ')).first || Ingredient.new(name: parts.join(' '))

    ri = RecipeItem.new(@options.merge(amount: amount, unit: unit, ingredient: ingredient))
    return ri.summary.blank? ? nil : ri
  end

  private def parts
    @parts ||= @str.split(' ')
  end

  private def string_to_number(str)
    number = if str.include?('/')
      Rational(str).to_f
    else
      str.to_f
    end
    number.round(2)
  end
end