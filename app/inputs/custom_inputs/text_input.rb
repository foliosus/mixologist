class CustomInputs::TextInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(
      # Enable auto-sizing of the input, ala https://css-tricks.com/the-cleanest-trick-for-autogrowing-textareas/
      input_html_options.merge(onInput: "this.parentNode.dataset.replicatedValue = this.value"),
      wrapper_options
    )

    template.content_tag(:div, class: "text_area_wrapper") do
      @builder.text_area(attribute_name, merged_input_options)
    end
  end
end