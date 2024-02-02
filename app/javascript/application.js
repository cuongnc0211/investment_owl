// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// For close flash message
document.body.addEventListener('click', function(event) {
  if (event.target.matches('.alert-close-custom')) {
    event.target.parentNode.style.display = 'none';
  }
});