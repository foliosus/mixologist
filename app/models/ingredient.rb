class Ingredient < ActiveRecord::Base
  has_many :recipe_items, inverse_of: :ingredient, dependent: :delete_all
  has_many :cocktails, through: :recipe_items
  belongs_to :ingredient_category, inverse_of: :ingredients

  validates_presence_of :name, :ingredient_category_id
  validates_uniqueness_of :name

  default_scope -> { order("LOWER(#{quoted_table_name}.name) ASC") }

  scope :named, ->(name) { where(["LOWER(#{quoted_table_name}.name) like ?", "%#{name.downcase}%"]) }

  def ==(other)
    return false unless other.is_a?(Ingredient)
    return self.name == other.name
  end

  def <=>(other)
    if self.ingredient_category != other.ingredient_category
      if self.ingredient_category&.base_spirit?
        -1
      elsif other.ingredient_category&.base_spirit?
        1
      else
        self.name.downcase <=> other.name.downcase
      end
    else
      self.name.downcase <=> other.name.downcase
    end
  end

  def to_hash
    {
      name: name,
      notes: notes,
      ingredient_category: ingredient_category.to_json
    }
  end
end
