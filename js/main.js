document.addEventListener('DOMContentLoaded', () => {
  const toogleTheme = document.querySelector('.darkmode-toggle');

  toogleTheme.addEventListener('click', function () {
    if (this.classList.contains('dark')) {
      document.documentElement.setAttribute('data-theme', 'lighttheme')
    } else {
      document.documentElement.setAttribute('data-theme', 'dartheme')
    }
    this.classList.toggle("dark");
  })
})