(function tle() {
  delegateEvent(document, '.control.cancel', 'click', ({ target }) => target.closest('.patch.container').remove());
  onEvent(document, 'click', ({ target }) => {
    const nf = document.querySelector('.new-flag');
    if (nf && !target.closest('.new-flag'))
      nf.remove();
  })
})();