let nav = document.getElementsByTagName("nav")[0];
let showNavBtn = document.getElementById("show-nav-btn");
let isNavVisible = true;

// window.addEventListener("resize", function () {
//   if (window.innerWidth <= 1000 && isNavVisible) {
//     // Change 600 to your breakpoint
//     hideNav();
//   } else if (window.innerWidth > 1000 && !isNavVisible) {
//     showNav();
//   }
// });

function hideNav() {
  nav.style.transform = "translateX(-100%)";
  nav.style.opacity = "0";
  setTimeout(() => {
    nav.style.display = "none";
    showNavBtn.style.display = "block";
  }, 500); // Delayed to sync with the transition duration
  isNavVisible = false;
}

function showNav() {
  showNavBtn.style.display = "none";
  nav.style.display = "flex";
  nav.style.opacity = "1";
  nav.style.transform = "translateX(0)";
  isNavVisible = true;
}

// Hide nav on page load for small screens
if (window.innerWidth <= 1000) {
  hideNav();
} else showNav();

// Event listener for header hrefs
var headers = document.querySelectorAll("h1, h2, h3, h4");
headers.forEach(function (header) {
  header.addEventListener("click", function (e) {
    if (e.target === header) {
      // Ensure we're clicking on the header itself
      location.hash = header.getAttribute("id");
      copyToClipboard(window.location.href);
    }
  });
});
// copy
function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(function() {
    console.log('Copying to clipboard was successful!');
  }, function(err) {
    console.error('Could not copy text: ', err);
  });
}

// handle search
var searchElem = document.getElementById("search");
searchElem.addEventListener("change", (e) => {
  // check if option is valid choice
  var options = e.target.list.options;
  var valid = false;
  for (var i = 0; i < options.length; i++) {
    if (e.target.value === options[i].value) {
      valid = true;
      break;
    }
  }
  if (!valid) {
    return;
  } else {
    console.log(e.target.value);
    window.location.href = e.target.value;
  }
  e.target.value = "";
});
