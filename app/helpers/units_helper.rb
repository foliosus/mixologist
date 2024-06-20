module UnitsHelper
  def unit_to_fraction(unit)
    unit.size_in_ounces.to_f.rationalize.to_s
  end
end
