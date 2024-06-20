require 'test_helper'

class IconTest < ActiveSupport::TestCase
  should "render an Icon to html" do
    icon = Icon.new(:trash)
    expected = '<span class="fa-solid fa-trash"></span>'
    assert_equal expected, icon.to_html
  end

  should "render an Icon to string as an alias of to_html" do
    icon = Icon.new(:trash)
    assert_equal icon.to_html, icon.to_s
  end

  should "alias icon names to the underlying library's names" do
    icon = Icon.new(:add)
    expected = '<span class="fa-solid fa-plus"></span>'
    assert_equal expected, icon.to_html
  end

  should "render an icon in the regular (not solid) style" do
    icon = Icon.new(:trash, style: :regular)
    expected = '<span class="fa-regular fa-trash"></span>'
    assert_equal expected, icon.to_html
  end
end
