FactoryBot.define do
  factory :cocktail do
    transient do
      garnishes_count { 1 }
    end

    sequence(:name){|n| "Corpse reviver ##{n}"}
    after(:build) do |cocktail, evaluator|
      cocktail.garnishes = build_list :garnish, evaluator.garnishes_count
    end
  end

  factory :unit do
    sequence(:name){|n| "foonit#{n}"}
    abbreviation { 'f' }
    size_in_ounces { 1 }
  end

  factory :ingredient do
    sequence(:name) {|n| "creme de foo#{n}"}
  end

  factory :ingredient_category do
    sequence(:name) {|n| "category number #{n}"}
  end

  factory :recipe_item do
    amount        { 1 }
    association   :cocktail, strategy: :build
    association   :ingredient, strategy: :build
    association   :unit, strategy: :build
  end

  factory :garnish do
    sequence(:name) {|n| "garnish number #{n}"}
  end
end