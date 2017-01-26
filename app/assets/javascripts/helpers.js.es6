function onEvent(target, type, handler) {
  target.addEventListener(type, handler);
}

function delegateEvent(target, selector, type, handler) {
  function dispatcher(event) {
    const targets = target.querySelectorAll(selector);
    let i         = targets.length;

    while (i--) {
      if (event.target === targets[i]) {
        handler(event);
        break;
      }
    }
  }

  onEvent(target, type, dispatcher);
}
