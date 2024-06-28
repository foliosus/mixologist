FactoryBot.define do
  factory :user do
    sequence(:email){|n| "user_#{n}@example.com"}
    password { "passwordpassword" }
    password_confirmation { password }
    confirmed_at { Time.zone.now - 1.minute }
  end

  factory :cocktail do
    transient do
      garnishes_count { 1 }
      recipe_items_count { 1 }
    end

    sequence(:name){|n| "Corpse reviver ##{n}"}
    recipe_items { build_list(:recipe_item, recipe_items_count) }
    technique { "shake" }

    after(:build) do |cocktail, evaluator|
      cocktail.garnishes = build_list(:garnish, evaluator.garnishes_count)
    end
  end

  factory :unit do
    sequence(:name){|n| "foounit#{n}"}
    abbreviation { 'fu' }
    size_in_ounces { 1 }

    trait :ounce do
      name { "ounce" }
      abbreviation { "oz" }
      size_in_ounces { 1 }
    end
  end

  factory :ingredient do
    sequence(:name) {|n| "creme de foo #{n}"}
    ingredient_category { IngredientCategory.first || build(:ingredient_category, :base_spirit) }
  end

  factory :ingredient_category do
    sequence(:name) {|n| "category #{n}"}

    trait :base_spirit do
      name { "Base spirit" }
    end
  end

  factory :recipe_item do
    amount        { 1 }
    ingredient { build(:ingredient) }
    unit { Unit.first || build(:unit) }
  end

  factory :garnish do
    sequence(:name) {|n| "garnish #{n}"}
  end
end