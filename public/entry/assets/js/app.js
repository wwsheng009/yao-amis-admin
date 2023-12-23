//Menu
/*********************/
/* Toggle Menu */
/*********************/
function toggleMenu() {
  document.getElementById("isToggle").classList.toggle("open");
  // display the menu
  document.getElementById("nav-menu").classList.toggle("open");

  if (document.getElementById("icon-hide").classList.contains("hidden")) {
    document.getElementById("icon-show").classList.toggle("hidden");
    document.getElementById("icon-hide").classList.remove("hidden");
  } else {
    document.getElementById("icon-show").classList.remove("hidden");
    document.getElementById("icon-hide").classList.toggle("hidden");
  }
}
// hide the menu
function showMenu(show) {
  if (!show) {
    // document.getElementById("nav-menu").classList.remove("open");
    document.getElementById("nav-menu").classList.toggle("hidden");

    document.getElementById("icon-show").classList.remove("hidden");
    document.getElementById("icon-hide").classList.toggle("hidden");
  }
}
