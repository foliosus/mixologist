// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Enable auto-growing textareas (see text_input.rb, simple_form.scss)
document.addEventListener("turbo:load", function() {
  let textareas = document.querySelectorAll("form.simple_form textarea")
  textareas.forEach(function(textarea, _, __) {
    textarea.dispatchEvent(new Event("input"))
  })
})
