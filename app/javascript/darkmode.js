const isDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches;
if (isDarkMode) {
  document.documentElement.setAttribute("data-bs-theme", "dark");
}
