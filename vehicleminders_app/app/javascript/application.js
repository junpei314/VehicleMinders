import "@hotwired/turbo-rails"
import "controllers"
import "custom/menu"
import $ from "jquery";
window.$ = $;
window.jQuery = $;
import "slick-carousel";

document.addEventListener("turbo:load", function() {
  $('.slider-3').slick({
    infinite: true,
    speed: 500,
    fade: true,
    slide: 'div',
    cssEase: 'linear',
    adaptiveHeight: true,
  });
});
