document.addEventListener('DOMContentLoaded', () => {
  const forms = document.querySelectorAll('form');

  forms.forEach(form => {
    form.addEventListener('submit', (event) => {
      const submitButton = form.querySelector('input[type="submit"], button[type="submit"]');

      if (submitButton && submitButton.dataset.loadingText) {
        submitButton.disabled = true;
        if (submitButton.tagName === 'INPUT') {
          submitButton.value = submitButton.dataset.loadingText;
        } else {
          submitButton.textContent = submitButton.dataset.loadingText;
        }
      }
    });
  });
});
