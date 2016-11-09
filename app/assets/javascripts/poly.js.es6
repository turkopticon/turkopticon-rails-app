if (typeof Element.prototype.closest !== 'function')
  Element.prototype.closest = function closest(selector) {
    let el = this;
    while (el && el.nodeType === 1) {
      if (el.matches(selector)) return el;
      el = el.parentNode;
    }
    return null;
  };
