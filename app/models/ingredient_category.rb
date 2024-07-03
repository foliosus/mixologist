class IngredientCategory < ActiveRecord::Base
  has_many :ingredients, inverse_of: :ingredient_category
  has_many :cocktails, through: :ingredients

  validates :name, presence: true, uniqueness: true

  default_scope lambda{ order('LOWER(name) ASC') }

  scope :named, lambda {|n| where(['LOWER(name) like ?', "%#{n.downcase}%"]) }

  def base_spirit?
    self.name == 'Base spirit'
  end

  def ==(other)
    return false unless other.is_a?(IngredientCategory)
    return self.name == other.name
  end

  def <=>(other)
    return -1 unless other.respond_to?(:downcase)
    if self.base_spirit? == other.base_spirit?
      self.name.downcase <=> other.name.downcase
    elsif self.base_spirit?
      -1
    else
      1
    end
  end

  # =============
  # Import/export
  # =============

  def self.import_from_hash(hsh)
    ingredient_category = find_or_initialize_by(hsh.slice(:name))
    ingredient_category.update(hsh)
    ingredient_category
  end

  def to_hash
    {
      name: name
    }
  end
end
