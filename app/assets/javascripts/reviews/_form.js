(function form(rf) {
  'use strict';
  const { data:{ pool }, data:{ tree }, error, validator, fn:{ get, getAll, make } } = rf;

  let anchor,//    get('.c2'),
      stateRef;//  get('#review_state');

  let model = {};

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

    model[opts.as || key] = _render(opts.as || key, pool[key], opts);
  }

  function _remove(key) {
    if (!(key in model)) return console.warn(`Key '${key}' not found in model`);

    model[key].block.remove();
    model[key] = null; // null for gc before deleting key
    delete model[key];
  }

  function _render(key, src, opt = {}) {
    const build     = {},
          ctrl      = src.control,
          def       = 'default' in opt ? opt.default : src.default,
          anchorRef = model.recommend && model.recommend.block || model.context.block;

    build.block = opt.to
      ? model[opt.to].block.appendChild(make('DIV', { class: 'inline pull right' }))
      : anchor.insertBefore(make('DIV'), anchorRef);

    if (src.title)
      build.block.appendChild(make('span', { class: 'question block' }))
        .textContent = src.title;

    ctrl.labels.desc.forEach((label, i) => {
      let acc;
      if (!label) {
        acc          = build.block.appendChild(make(ctrl.tag, ctrl.attrs));
        acc.onchange = _update;
        acc.name     = key;
      } else {
        const opt    = build.block.appendChild(make('label', { class: ctrl.labels.class }));
        acc          = opt.appendChild(make(ctrl.tag, ctrl.attrs));
        acc.value    = ctrl.values[i];
        acc.name     = key;
        acc.onchange = _update;
        opt.appendChild(document.createTextNode(label));
      }

      if ((def === true && acc.type === 'checkbox')
          || (acc.type === 'radio' && def === acc.value))
        acc.checked = true;
      else if (acc.type === 'text') acc.value = def
    });

    build.ref        = getAll(`[name=${key}]`, build.block);
    build.value      = def;
    build.validators = src.validators;
    if (build.ref[0].type === 'number') _setNumFields(key, def, build.ref);

    return build;
  }

  function _setNumFields(name, value, elRefs) {
    const values = [0, value];
    if (!value) return null;
    else if (name === 'time' && value > 60 - 1) {
      values[0] = Math.floor(value / 60);
      values[1] = value % 60;
    }
    else if (name === 'time_pending' && value > 86400 - 1) {
      values[0] = Math.floor(value / 86400);
      values[1] = Math.floor(value % 86400 / 3600);
    }
    elRefs.forEach((el, i) => el.value = values[i]);
  }

  function _update(e) {
    const el = e.target;
    switch (el.type) {
      case 'checkbox':
        model[el.name].value = el.checked;
        break;
      case 'radio':
        if (el.checked) model[el.name].value = el.value;
        break;
      case 'number':
        if (el.name === 'reward')
          model[el.name].value = (+el.value);
        else { // reduce everything down to seconds
          const group = getAll('[type=number]', el.parentNode.parentNode),
                lcv   = [24, 60, 60, 1].slice(el.name === 'time' ? -2 : 0);

          model[el.name].value = group.map(v => +v.value).reduce((a, b, i) => lcv[i] * (a + b), 0);
          model[el.name].value *= el.name === 'time' ? 1 : 60;
          model[el.name].value = Math.ceil(model[el.name].value);
        }
        break;
      default:
        model[el.name].value = el.value.trim();
    }

    _validate(model[el.name]);
    _mutate(el.name, model[el.name].value);
    stateRef.value = _serialize();
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
    // reset dependent references to prevent breakage after browser history navigation
    anchor   = get('.c2');
    stateRef = get('#review_state');

    const state = JSON.parse(stateRef.value);

    'title reward rname rid context'.split(' ').forEach(v => {
      // if (v in model) return;
      model[v]       = { ref: getAll(`[name=${v}]`) };
      model[v].value = model[v].ref[0].value = state[v];
      model[v].ref[0].onchange = _update;
      model[v].validators      = pool[v].validators;
      model[v].block           = model[v].ref[0].closest('div');
      delete state[v];
    });

    // remove orphaned elements from history navigation
    getAll('div', anchor).forEach(el => el.remove());
    anchor.insertBefore(model.context.block, anchor.lastElementChild);

    if (Object.keys(state).length) // restore from state
      Object.keys(state).forEach(k => {
        const ctx   = /_context/.test(k),
              ctxTo = ctx ? k.split('_')[0] : null,
              opt   = { as: k, default: state[k], to: ctx ? ctxTo : null };
        if (!((ctx ? ctxTo : k) in pool)) return;
        _add(ctx ? '_context' : k, opt);
      });
    else // create default skeleton
      'tos broken deceptive completed'.split(' ').forEach(v => !(v in model) && _add(v));

    get('.submit').onclick = e => {if (!rf.form.isValid) e.preventDefault(); else (window._rf = null)};
  }

  function _serialize(n = 0) {
    const json = Object.keys(model).reduce((a, b) => {
      a[b] = model[b].value;
      return a
    }, {});
    return JSON.stringify(json, null, n);
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
    else {
      stateRef.value = _serialize();
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
  }
})(window._rf);
