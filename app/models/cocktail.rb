class Cocktail < ActiveRecord::Base
  has_many :recipe_items, inverse_of: :cocktail, dependent: :delete_all
  has_many :ingredients, through: :recipe_items
  has_and_belongs_to_many :garnishes, inverse_of: :cocktails

  accepts_nested_attributes_for :recipe_items,
                                reject_if: proc {|attribs| attribs.values.all?{|v| v.blank?} }

  default_scope -> { order("LOWER(#{table_name}.sort_name) ASC") }

  scope :full_recipe, -> { includes([
    { recipe_items: [:unit, {:ingredient => :ingredient_category}]},
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

  before_save :set_sort_name!, if: Proc.new {|cocktail| cocktail.name_changed? }

  def set_sort_name!
    self.sort_name = UnicodeUtils.simple_casefold(self.name)
    %w(the and).each do |stop_word|
      self.sort_name.gsub!(/(\A)?#{stop_word}\s/i, '')
    end
  end

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

  def recipe_items_blob
    recipe_items.collect(&:summary).join("\n")
  end

  def recipe_items_blob=(new_blob)
    self.recipe_items = RecipeItemProcessor.process(self, new_blob.strip.gsub("\r", '').split("\n"))
  end

  def full_technique
    if garnishes.blank?
      technique
    else
      garnishes_text = garnishes.collect{|g| "a #{g.name}"}
      "#{technique}, garnish with #{garnishes_text.to_sentence}"
    end
  end

  def to_hash
    {
      name: name,
      notes: notes,
      technique: technique,
      recipe_items: recipe_items.collect(&:to_json),
      garnishes: garnishes.collect(&:to_json)
    }
  end
end
