(function commentsController() {
  [].forEach.call(document.querySelectorAll('.comments-divider a'), a => {
    a.onclick = e => {
      e.preventDefault();
      const el                                    = e.target,
            hide                                  = el.textContent === '(hide)';
      el.textContent                              = hide ? '(show)' : '(hide)';
      el.closest('.col-review')
        .querySelector('.comments').style.display = hide ? 'none' : 'block';
    }
  });
})();