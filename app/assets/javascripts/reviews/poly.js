if (typeof Element.prototype.closest !== 'function')
  Element.prototype.closest = function closest(selector) {
    let el = this;
    while (el && el.nodeType === 1) {
      if (el.matches(selector)) return el;
      el = el.parentNode;
    }
    return null;
  };


(function helper(rf) {
  rf.fn = rf.fn || {
      get   : (...args) => (args[1] || document).querySelector(args[0]),
      getAll: (...args) => Array.from((args[1] || document).querySelectorAll(args[0])),
      make  : (tag, attrs = {}) => {
        const el = document.createElement(tag);
        Object.keys(attrs).forEach(attr => el.setAttribute(attr, attrs[attr]));
        return el;
      }
    };
})(window._rf || (window._rf = {}));

