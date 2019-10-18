document.addEventListener('DOMContentLoaded', () => {
  const toogleTheme = document.querySelector('.darkmode-toggle');

  if (localStorage.getItem('theme') == 'darkTheme') {
    document.documentElement.setAttribute('data-theme', 'darkTheme')
    toogleTheme.classList.add('dark')
  }

  toogleTheme.addEventListener('click', function () {
    const theme = this.classList.contains('dark') ? 'lightTheme' : 'darkTheme';
    document.documentElement.setAttribute('data-theme', theme)
    localStorage.setItem('theme', theme)
    this.classList.toggle("dark");
  })
})