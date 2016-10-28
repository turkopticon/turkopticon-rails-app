(function form(rf) {
  'use strict';
  const model                                                                        = {},
        { data:{ pool }, data:{ tree }, error, validator, fn:{ get, getAll, make } } = rf,
        anchor                                                                       = get('.c2');

  rf.form = rf.form || {
      init    : _init,
      validate: _validate,
      get model() {
        return model;
      },
      get value() {
        return _value();
      },
      get json() {
        return _serialize(2);
      },
      get isValid() {
        return Object.keys(_validate()).length === 0;
      }
    };

  function _add(key, opts = {}) {
    if (!(key in pool)) return console.warn(`Invalid key '${key}'`);

    opts = Object.assign({ as: null, to: null }, opts);

    model[opts.as || key] = _render(opts.as || key, pool[key], opts.to);
  }

  function _remove(key) {
    if (!(key in model)) return console.warn(`Key '${key}' not found in model`);

    model[key].block.remove();
    model[key] = null; // null for gc before deleting key
    delete model[key];
  }

  function _render(key, src, to) {
    const build     = {},
          ctrl      = src.control,
          def       = 'default' in src && src.default,
          anchorRef = model.recommend && model.recommend.block || model.comments.block;

    build.block = to
      ? model[to].block.appendChild(make('DIV', { class: 'inline pull right' }))
      : anchor.insertBefore(make('DIV'), anchorRef);

    if (src.title)
      build.block.appendChild(make('span', { class: 'question block' }))
        .textContent = src.title;

    ctrl.labels.desc.forEach((label, i) => {
      if (!label) {
        const acc    = build.block.appendChild(make(ctrl.tag, ctrl.attrs));
        acc.onchange = _update;
        acc.name     = key;
      } else {
        const opt    = build.block.appendChild(make('label', { class: ctrl.labels.class })),
              acc    = opt.appendChild(make(ctrl.tag, ctrl.attrs));
        acc.value    = ctrl.values[i];
        acc.name     = key;
        acc.onchange = _update;
        opt.appendChild(document.createTextNode(label));

        if (typeof def === 'number' && def === i) acc.checked = true;
      }
    });

    build.ref        = getAll(`[name=${key}]`, build.block);
    build.value      = 'default' in src ? (typeof def === 'string' ? def : ctrl.values[def]) : null;
    build.validators = src.validators;

    return build;
  }

  function _update(e) {
    const el = e.target;
    switch (el.type) {
      case 'checkbox':
        model[el.name].value = el.checked.toString();
        break;
      case 'radio':
        if (el.checked) model[el.name].value = el.value;
        break;
      case 'number':
        if (el.name === 'reward')
          model[el.name].value = (+el.value).toString();
        else { // reduce everything down to seconds
          const group = getAll('[type=number]', el.parentNode.parentNode),
                lcv   = [24, 60, 60, 1].slice(el.name === 'time' ? -2 : 0);

          model[el.name].value = group.map(v => +v.value).reduce((a, b, i) => lcv[i] * (a + b), 0);
          model[el.name].value *= el.name === 'time' ? 1 : 60;
          model[el.name].value = Math.ceil(model[el.name].value).toString();
        }
        break;
      default:
        model[el.name].value = el.value.trim();
    }

    _validate(model[el.name]);
    _mutate(el.name, model[el.name].value);
  }

  function _mutate(key, value) {
    const branch = tree[key];
    if (branch && branch.add.if.includes(value.toString()))
    // add children if not already in model
      branch.children.forEach((child, i) => {
        const opt = branch.as ? { as: branch.as[i], to: key } : {};
        if (!((opt.as || child) in model)) _add(child, opt);
      });
    else if (branch && branch.remove.if.includes(value.toString()))
    // remove children and grandchildren if exists
      [...(branch.as || branch.children), ...(branch.remove.grandchildren || [])]
        .forEach(child => (child in model) && _remove(child));
  }

  function _init() {
    'title reward rname rid comments'.split(' ').forEach(v => {
      if (v in model) return;
      model[v]                 = { ref: getAll(`[name=${v}]`) };
      model[v].value           = model[v].ref[0].value;
      model[v].ref[0].onchange = _update;
      model[v].validators      = pool[v].validators;
      model[v].block           = model[v].ref[0].closest('div');
    });

    'tos broken deceptive completed'.split(' ').forEach(v => !(v in model) && _add(v));

    get('a.submit').addEventListener('click', e => e.preventDefault())
  }

  function _serialize(n = 0) {
    return JSON.stringify(model, ['value', ...Object.keys(model)], n);
  }

  function _value() {
    return JSON.parse(_serialize());
  }

  function _validate(field) {
    if (field) { // run validation on a single field set
      error.clear(field);

      // run validators and filter out passed results
      const result = Object.keys(field.validators)
                           .map(v => validator[v](field.value, ...field.validators[v]))
                           .filter(v => !v[0]);

      if (result.length) error.add(field, result[0]);
    }
    // manually trigger validation on entire model
    // returns an obj with all failed fields and their validators
    else
      return Object.keys(model).reduce((obj, key) => {
        const src        = model[key],
              validators = Object.keys(src.validators),
              result     = validators.map(v => validator[v](src.value, ...src.validators[v]));

        // some validators failed; record it in return obj and set error classes in DOM
        if (!(result.reduce((a, b) => a && b[0], true))) {
          obj[key] = result.reduce((a, b, i) => b[0] === false ? (a[validators[i]] = b) && a : a, {});
          error.add(src, result.filter(v => !v[0])[0]);
        }
        return obj;
      }, {});
  }
})(window._rf);
