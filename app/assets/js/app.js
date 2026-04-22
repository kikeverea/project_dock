(function () {
  function init() {
    // Sidebar toggle
    var toggle = document.getElementById('sidebar-toggle');
    if (toggle) {
      toggle.addEventListener('click', function () {
        document.body.classList.toggle('sidebar-collapsed');
      });
    }

    // Mark active sidebar links and open parent <details> if nested
    var currentUrl = window.location.href.split(/[?#]/)[0];
    var sidebar = document.getElementById('sidebar');
    if (sidebar) {
      sidebar.querySelectorAll('a').forEach(function (link) {
        if (link.href === currentUrl) {
          link.classList.add('active');
          var details = link.closest('details');
          if (details) details.open = true;
        }
      });
    }

    // Bootstrap tooltips and popovers
    if (typeof bootstrap !== 'undefined') {
      document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (el) {
        new bootstrap.Tooltip(el);
      });
      document.querySelectorAll('[data-bs-toggle="popover"]').forEach(function (el) {
        new bootstrap.Popover(el);
      });
    }
  }

  document.addEventListener('DOMContentLoaded', init);
  document.addEventListener('turbo:load', init);
})();
