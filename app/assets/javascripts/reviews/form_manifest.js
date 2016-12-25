//require ./_helper.js.es6
//require ./_data.js.es6
//require ./_validator.js.es6
//require ./_error.js.es6
//require ./_form.js.es6

//window._rf.form.init();

(function () {

  class Validator {
    static required(value) {
      return value !== null && value !== undefined && value.toString().length > 0 ? [true, null] : [false, 'Required'];
    }

    static valueGreaterThan(value, min, name, units) {
      return value && value > min
        ? [true, null]
        : [false, `${name || 'Value'} must be greater than ${min} ${units || ''}`];
    }

    static lengthGreaterThan(value, min) {
      return value && value.length > min ? [true, null] : [false, `Length must be greater than ${min}`];
    }

    static lengthBetween(value, min, max) {
      return value && value.length <= max && value.length >= min
        ? [true, null]
        : [false, `Length (${value.length}) must be between ${min} and ${max}`]
    }

    static negPattern(value, re, name) {
      return value && re.test(value) ? [false, `Improperly formatted ${name || 'value'}`] : [true, null];
    }

    static pattern(value, re, name) {
      return value && re.test(value) ? [true, null] : [false, `Improperly formatted ${name || 'value'}`];
    }
  }

  class FormStore {
    constructor() {
      this.store = {};
      this.state = document.querySelector('#review_state');
    }

    get value() { return this.serialize(); }

    remove(field) {
      delete this.store[field];
    }

    update(field, properties, overwrite = true) {
      if (!overwrite && this.store.hasOwnProperty(field)) return;

      this.store[field] = Object.assign(this.store[field] || {}, properties);
      this.state.value  = this.value;
    }

    serialize(n = 0) {
      const json = Object.keys(this.store).reduce((a, b) => {
        a[b] = this.store[b].value;
        return a
      }, {});
      return JSON.stringify(json, null, n);
    }
  }

  class FormControl {
    constructor(store, view, validators) {
      this.store      = store || new FormStore();
      this.view       = view || new FormView();
      this.validators = validators;

      this.view.bindMutateTime(this.updateField.bind(this));
      this.view.bindMutateContext(this.removeField.bind(this));
      onEvent(this.view.form, 'change', ({ target }) => this.validate(target.closest('fieldset')));

      this.view.restore(JSON.parse(this.store.state.value));
      this.view.fields.forEach(field => this.updateField(field, { value: getValueOf(field) }));
    }

    removeField(field) {
      this.store.remove(field.dataset.name);
    }

    updateField(field, props) {
      const error = props.error;

      this.store.update(field.dataset.name, props);
      FormView.manageError(field, error || null);
    }

    validate(field) {
      const props      = { value: getValueOf(field) },
            validators = this.validators[field.dataset.role],
            result     = validators && Object.keys(validators)
                                             .map(v => Validator[v](props.value, ...validators[v]))
                                             .filter(v => !v[0]) || [];

      if (field.dataset.type === 'time' && result.length && field.querySelector('.mutator:checked') && /greater/.test(result[0][1]))
        void(result.shift());
      props.isvalid = result.length ? result[0][0] : true;
      props.error   = result.length ? result[0][1] : null;
      this.updateField(field, props, field)
    }

    get isValid() {
      return this.view.fields.filter(f => f.classList.contains('validation-error')).length === 0;
    }
  }

  class FormView {
    constructor() {
      this.form = document.querySelector('.form.flex');
    }

    get allFields() { return Array.from(this.form.querySelectorAll('fieldset')); }

    get fields() { return Array.from(this.form.querySelectorAll('fieldset:not(.hidden)')); }

    bindMutateContext(callback) {
      delegateEvent(this.form, '.mutator.context', 'click', ({ target }) => {
        const context = this.form.querySelector(`fieldset[data-name=${target.name}_context]`);

        if (target.value !== 'n/a')
          context.classList[target.checked ? 'remove' : 'add']('hidden');
        else
          context.classList.add('hidden');

        if (context.classList.contains('hidden')) {
          context.querySelector('input').value = null;
          context.classList.remove('validation-error');
          context.dataset.error = null;
          callback(context);
        }
      });
    }

    bindMutateTime(callback) {
      function mutate(field, handler) {
        const mutationTargets = Array.from(field.querySelectorAll('[type=number]')),
              isChecked       = [].some.call(field.querySelectorAll('[type=checkbox]'), el => el.checked);
        if (isChecked)
          handler(mutationTargets, { disabled: true, value: null });
        else
          handler(mutationTargets, { disabled: false });
      }

      delegateEvent(this.form, '.mutator:not(.context)', 'click', ({ target }) => {
        const parent = target.closest('fieldset');

        mutate(parent, (targets, props) => Object.keys(props).forEach(p => targets.forEach(t => t[p] = props[p])));
        callback(parent, { value: getValueOf(parent) });
      });
    }

    static manageError(field, error) {
      field.dataset.error = error;
      field.classList[error ? 'add' : 'remove']('validation-error');
    }

    restore(state) {
      this.allFields
          .filter(f => f.dataset.name in state)
          .forEach(f => setValueOf(f, state[f.dataset.name]));
    }
  }

  function getValueOf(field) {
    const { name, type } = field.dataset;

    switch (type) {
      case 'radio':
        const checked = field.querySelector(':checked');
        return checked && checked.value;
      case 'checkbox':
        return field.querySelector(':checked') && true || false;
      case 'time':
        const group = Array.from(field.querySelectorAll('[type=number]:not(:disabled)'));

        if (!group.length) // user checked "don't know" option or similar
          return +field.querySelector(':checked').value;

        const lcv   = [24, 60, 60, 1].slice(name === 'time' ? -2 : 0),
              value = group.map(v => +v.value).reduce((a, b, i) => lcv[i] * (a + b), 0);

        return Math.ceil(value * (name === 'time' ? 1 : 60));
      default:
        return field.querySelector(`[name=${name}]`).value;
    }
  }

  function setValueOf(field, value) {
    const { name, type } = field.dataset;

    switch (type) {
      case 'radio':
        return field.querySelector(`[value="${value}"]`).click();
      case 'checkbox':
        return value && field.querySelector(`[name=${name}]`).click();
      case 'time':
        if (value < 1)
          return field.querySelector(`[value="${value}"]`).click();

        const values = [0, value];
        if (name === 'time' && value >= 60) {
          values[0] = Math.floor(value / 60);
          values[1] = value % 60;
        } else if (name === 'time_pending') {
          values[0] = Math.floor(value / 86400);
          values[1] = values[0] === 0 ? +(value / 3600).toFixed(2) : Math.floor(value % 86400 / 3600);
        }
        return [].forEach.call(field.querySelectorAll('[type=number]'), (el, i) => el.value = values[i]);
      default:
        field.querySelector(`[name=${name}]`).value = value;
    }
  }

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

  const validators = {
    default: { required: [] },
    reward : { required: [], pattern: [/^(\d*(\.\d{0,2})?$)/, 'reward'] },
    id     : { required: [], lengthGreaterThan: [7], negPattern: [/[^A-Z0-9]/, 'requester ID'] },
    context: { required: [], lengthBetween: [5, 200] },
    time   : { required: [], valueGreaterThan: [0, 'Time', 'seconds'] },
  };

  console.log(document.querySelector('#review_state').value);
  const fc = new FormControl(null, null, validators);

  fc.view.form.querySelector('[type=submit].submit.block').addEventListener('click', e => {
    e.stopImmediatePropagation();
    fc.view.fields.forEach(fc.validate.bind(fc));
    fc.store.state.value = fc.store.value;
    if (!fc.isValid) {
      e.preventDefault();
      const { top } = fc.view.form.querySelector('.validation-error').getBoundingClientRect();
      window.scrollBy(0, top - 10);
    }
  });

})();
