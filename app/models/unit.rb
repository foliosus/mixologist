class Unit < ActiveRecord::Base
  has_many :recipe_items, inverse_of: :unit, dependent: :delete_all

  validates_length_of :name, within: 1..40, allow_blank: false
  validates_length_of :abbreviation, within: 1..4, allow_blank: false
  validates_numericality_of :size_in_ounces, greater_than: 0, allow_nil: false

  default_scope lambda{ order('size_in_ounces DESC') }

  scope :named, lambda {|n|
    where('LOWER(name) like :n OR LOWER(abbreviation) LIKE :n', n: "%#{n.to_s.singularize.downcase}%")}

  def <=>(other)
    self.size_in_ounces <=> other.size_in_ounces
  end

  def abbreviation_for_amount(amount)
    return abbreviation unless name == abbreviation
    amount == 1 ? abbreviation : abbreviation.pluralize
  end

  # =============
  # Import/export
  # =============

  def self.import_from_hash(hsh)
    unit = find_or_initialize_by(hsh.slice(:name))
    unit.update(hsh)
    unit
  end

  def to_hash
    {
      name: name,
      abbreviation: abbreviation,
      size_in_ounces: size_in_ounces
    }
  end
end
