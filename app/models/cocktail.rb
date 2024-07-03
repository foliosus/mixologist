class Cocktail < ActiveRecord::Base
  ALLOWED_TECHNIQUES = ['shake', 'stir', 'special (see notes)']

  has_many :recipe_items, inverse_of: :cocktail, dependent: :delete_all
  has_many :ingredients, through: :recipe_items
  has_and_belongs_to_many :garnishes, inverse_of: :cocktails

  # ===========
  # Validations
  # ===========

  validates_presence_of :name
  validates_presence_of :recipe_items_blob
  validates_inclusion_of :technique, in: ALLOWED_TECHNIQUES, allow_blank: false

  accepts_nested_attributes_for :recipe_items,
                                reject_if: proc {|attribs| attribs.values.all?{|v| v.blank?} }

  # ============
  # Query scopes
  # ============

  default_scope -> { order("LOWER(#{table_name}.sort_name) ASC") }

  scope :full_recipe, -> { includes([
    {
      recipe_items: [
        :unit,
        {:ingredient => :ingredient_category}
      ]
    },
    :garnishes
  ]) }

  scope :keywords, ->(keywords_array) {
    where(id: find_cocktail_ids_for_keywords(keywords_array))
  }

  scope :without_keywords, ->(keywords_array) {
    where.not(id: find_cocktail_ids_for_keywords(keywords_array))
  }

  scope :with_and_without_keywords , ->(keyword_list) {
    positives = find_cocktail_ids_for_keywords(keyword_list[:positive])
    negatives = find_cocktail_ids_for_keywords(keyword_list[:negative])
    if positives.present?
      where(id: positives - negatives)
    elsif negatives.present?
      where.not(id: negatives)
    else
      # We're searching for everything, apparently. Good job, user!
      where('1 = 2')
    end
  }

  # ===================
  # Lifecycle callbacks
  # ===================

  before_save :set_sort_name!, if: Proc.new {|cocktail| cocktail.name_changed? }

  def set_sort_name!
    self.sort_name = UnicodeUtils.simple_casefold(self.name)
    %w(the and).each do |stop_word|
      self.sort_name.gsub!(/(\A)?#{stop_word}\s/i, '')
    end
  end

  # ==============
  # Search support
  # ==============

  def self.find_cocktail_ids_for_keywords(keywords_array)
    return [] unless keywords_array.present?

    ingredient_id_arrays = keywords_array.collect do |keyword|
      Ingredient.named(keyword).pluck(:id)
    end
    if ingredient_id_arrays.present?
      cocktail_ids = ingredient_id_arrays.collect do |ingredient_ids|
        Cocktail.joins(:ingredients).where(ingredients: {id: ingredient_ids}).pluck(:id)
      end
      cocktail_ids.inject(:&)
    else
      # Because we have no ingredient_ids, nothing will match, so return []
      []
    end
  end

  # =============================
  # Recipe items parsing/emitting
  # =============================

  def recipe_items_blob
    recipe_items.collect(&:summary).join("\n")
  end

  def recipe_items_blob=(new_blob)
    blob = (new_blob || "").strip.gsub("\r", '').split("\n")
    self.recipe_items = RecipeItem::Processor.process(self, blob)
  end

  # =========
  # Technique
  # =========

  def self.techniques
    ALLOWED_TECHNIQUES
  end

  def full_technique
    if garnishes.blank?
      technique
    else
      garnishes_text = garnishes.collect{|g| "a #{g.name}"}
      "#{technique}, garnish with #{garnishes_text.to_sentence}"
    end
  end

  # =============
  # Import/export
  # =============

  def self.import_from_hash(hsh)
    cocktail = find_or_initialize_by(hsh.slice(:name))
    garnish_names = hsh.delete(:garnishes)
    if garnish_names.present?
      cocktail.garnishes = Garnish.where(name: garnish_names).all
    end
    cocktail.update(hsh)
    cocktail
  end

  def to_hash
    {
      name: name,
      notes: notes.present? ? notes : nil,
      technique: technique,
      recipe_items_blob: recipe_items_blob,
      garnishes: garnishes.collect(&:name)
    }
  end
end
