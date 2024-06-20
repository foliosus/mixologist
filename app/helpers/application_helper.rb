module ApplicationHelper
  FRACTION_REPLACEMENTS = {
    '1/2' => '&frac12;',
    '1/4' => '&frac14;',
    '3/4' => '&frac34;',
    '1/3' => '&frac13;',
  }

  # Set the page title
  def page_title(title)
    @page_title = title
  end

  # Show all of the flash messages
  def show_flash
    output = ''.html_safe
    flash.each do |level, message|
      next unless level.in?([:notice, :info, :warning, :error])
      output << content_tag(:div, h(message), class: level)
    end
    content_tag(:div, output, id: 'flash') unless output.empty?
  end

  # Show the fractions with correct HTML markup
  def html_fractions(text)
    new_text = text.dup
    FRACTION_REPLACEMENTS.each do |original, replacement|
      new_text.gsub!(original, replacement)
    end
    new_text.gsub!(/(\d)\s&/, '\1&')
    new_text.gsub!(/(\d{1,2})\/(\d{1,2})/, '<sup>\1</sup>&frasl;<sub>\2</sub>')
    sanitize(new_text)
  end
end
