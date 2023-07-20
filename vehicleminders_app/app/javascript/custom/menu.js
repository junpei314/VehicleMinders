// メニュー操作

// トグルリスナーを追加してクリックをリッスンする
document.addEventListener("turbo:load", function() {
  // let hamburger = document.querySelector("#hamburger");
  // hamburger.addEventListener("click", function(event) {
  //   event.preventDefault();
  //   let menu = document.querySelector("#navbar-menu");
  //   menu.classList.toggle("collapse");
  // });
  let account = document.querySelector("#account");
  let menu = document.querySelector("#dropdown-menu");

  account.addEventListener("click", function(event) {
    event.stopPropagation();
    event.preventDefault();
    menu.classList.toggle("active");
  });

  document.addEventListener("click", function(event) {
    if (menu.classList.contains("active")) {
      menu.classList.remove("active");
    }
  });
});