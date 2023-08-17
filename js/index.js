let nav = document.getElementsByTagName("nav")[0];
let showNavBtn = document.getElementById("show-nav-btn");
let isNavVisible = true;

window.addEventListener("resize", function () {
  if (window.innerWidth <= 1000 && isNavVisible) {
    // Change 600 to your breakpoint
    hideNav();
  } else if (window.innerWidth > 1000 && !isNavVisible) {
    showNav();
  }
});

function hideNav() {
  nav.style.transform = 'translateX(-100%)';
  nav.style.opacity = '0';
  setTimeout(() => {
      nav.style.display = 'none';
      showNavBtn.style.display = "block";
  }, 500); // Delayed to sync with the transition duration
  isNavVisible = false;
}

function showNav() {
  showNavBtn.style.display = "none";
  nav.style.display = 'flex';
  nav.style.opacity = '1';
  nav.style.transform = 'translateX(0)';
  isNavVisible = true;
}

// Hide nav on page load for small screens
if (window.innerWidth <= 1000) {
  hideNav();
} else showNav();
