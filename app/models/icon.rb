class Icon
  ALLOWED_STYLES = ["solid", "regular"]

  def initialize(icon_name, style: "solid")
    @icon_name = icon_name
    @style = style
    raise ArgumentError, "Style must be either 'solid' or 'thin' but was given as #{style}" unless @style.in?(ALLOWED_STYLES)
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

