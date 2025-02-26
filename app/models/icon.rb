class Icon
  ALLOWED_STYLES = %i[solid regular]

  BRAND_ICONS = %i[github linkedin]

  def initialize(icon_name, style: :solid)
    @icon_name = icon_name
    @style = icon_name.to_sym.in?(BRAND_ICONS) ? :brands : style.to_sym
    raise ArgumentError, "Style must be one of #{ALLOWED_STYLES} but was given as #{style.inspect}" unless @style.in?(ALLOWED_STYLES) || @style == :brands
  end

  def to_html
    "<span class=\"#{css_class}\"></span>".html_safe
  end

  def to_s
    to_html
  end

  private def css_class
    "fa-#{@style} fa-#{translated_icon_name}"
  end

  private def translated_icon_name
    case @icon_name
    when :add then :plus
    else
      @icon_name
    end
  end
end
