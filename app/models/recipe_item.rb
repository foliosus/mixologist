class RecipeItem < ActiveRecord::Base
  belongs_to :cocktail, inverse_of: :recipe_items
  belongs_to :ingredient, inverse_of: :recipe_items
  belongs_to :unit, inverse_of: :recipe_items, optional: true # Optional, because of unitless items like eggs

  default_scope ->{ order('amount DESC') }

  # Sort by volume first, then base spirits, then alphabetically
  def <=>(other)
    if self.total_volume == other.total_volume
      self.ingredient <=> other.ingredient
    else
      if self.total_volume.blank?
        1
      elsif other.total_volume.blank?
        -1
      else
        other.total_volume <=> self.total_volume
      end
    end
  end

  def total_volume
    @total_volume ||= self.amount? ? self.amount * (self.unit&.size_in_ounces || 1) : 0
  end

  def convert_to_cups!
    if self.total_volume >= 8
      self.amount = amount/8
      self.unit = Unit.find_by_name('cup') || Unit.new(name: "cup", abbreviation: "cup", size_in_ounces: 8)
    end
  end

  def summary
    return '' unless self.ingredient

    if amount.present?
      # Ruby Rational(3).to_s returns '3/1', and we don't want the '/1' bit
      rational = Rational(amount)
      amount_str = if rational.denominator == 1
        rational.numerator.to_s
      else
        integer = rational.to_i
        integer > 0 ? "#{integer.to_i} #{(rational - integer).to_s}" : "#{rational.to_s}"
      end
    else
      amount_str = ''
    end

    unit_str = self.unit.present? ? self.unit.abbreviation_for_amount(self.amount) : ''

    "#{amount_str} #{unit_str} #{ingredient.try(:name)}".squish
  end

  def summary=(new_val)
    if new_val.blank?
      self.amount = nil
      self.unit = nil
      self.ingredient = nil
      return ''
    end

    ri = RecipeItem.parse_from_string(new_val)
    self.amount = ri.amount
    self.unit = ri.unit
    self.ingredient = ri.ingredient
    return self.summary
  end

  def to_hash
    {
      amount: amount,
      unit: unit.to_json,
      ingredient: ingredient.to_json
    }
  end

  def self.parse_from_string(str, options = {})
    RecipeItemParser.new(str, options).parse!
  end
end
