module CocktailsHelper
  def new_cocktail_link
    link_to "#{Icon.new(:add)} Create a new cocktail".html_safe, new_admin_cocktail_path, class: 'call_to_action'
  end
end
