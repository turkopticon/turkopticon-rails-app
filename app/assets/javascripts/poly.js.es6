if (typeof Element.prototype.closest !== 'function')
  Element.prototype.closest = function closest(selector) {
    let el = this;
    while (el && el.nodeType === 1) {
      if (el.matches(selector)) return el;
      el = el.parentNode;
    }
    return null;
  };

if (typeof Array.prototype.find !== 'function')
  Array.prototype.find = function find(callback, thisArg = null) {
    if (typeof callback !== 'function') throw new TypeError('callback must be a function');
    for (let i = 0; i < this.length; i++)
      if (callback.call(thisArg, this[i], i, this))
        return this[i];

    return undefined;
  };