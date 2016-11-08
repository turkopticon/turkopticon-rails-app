(function error(rf) {
  'use strict';
  const { fn:{ get, make } } = rf;
  rf.error                   = rf.error || { add: _add, clear: _clear };

  function _add(src, error) {
    if (src.block.classList.contains('validation-error')) return null;
    src.block.classList.add('validation-error');
    const errSpan       = src.block.insertBefore(make('span', { class: 'validation-error' }), src.block.firstChild);
    errSpan.textContent = error[1];
  }

  function _clear(src) {
    src.block.classList.remove('validation-error');

    // remove trouble child to prevent false positives
    const detailChild = get('div.inline', src.block);
    detailChild && detailChild.remove();
    // clear errors in block
    const errSpan = get('span.validation-error', src.block);
    errSpan && errSpan.remove();
    // reattach child
    detailChild && src.block.appendChild(detailChild);
  }
})(window._rf);
