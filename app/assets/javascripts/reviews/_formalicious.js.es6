(function () {
  let form = qs('.rf.flex')
  const mutator = Symbol('mutator')
  const mutatorScope = Symbol('mutatorScope')

  onEvent(form, 'change', change)
  onEvent(qs('[type=submit]', form), 'click', e => {
    e.stopImmediatePropagation()
    if (!validateAll()) {
      e.preventDefault()
      const { top } = qs('.validation-error', form).getBoundingClientRect()
      window.scrollBy(0, top - 10)
    } else {
      form.removeEventListener('change', change)
      form = null
    }
  })

  qsa('.mutator', form).forEach(node => {
    node[mutator] = true
    node[mutatorScope] = node.dataset['mutate']
    node.removeAttribute('data-mutate')
    if (node.checked) {
      const field = node.closest('.field')
      node[mutatorScope].split(' ').forEach(scope => mutate(scope, { entry: node, ctx: field }))
    }
  })
  qsa('input[type=hidden]', form)
    .filter(el => ~el.name.indexOf('review') && !~el.name.indexOf('attr'))
    .forEach(el => {
      const field = el.closest('.field')
      if (el.value < 0) {
        const sel = `input:not([type=hidden])[value="${el.value}"]`
        qs(sel, field).click()
      } else if (field.dataset.type === 'time')
        fillTime(el.value, field)
    })

  // ------
  const validators = {
    required(value) {
      const notEmpty = value !== null && value !== undefined && value.toString().trim().length > 0
      return notEmpty ? [true, null] : [false, 'Required'];
    },
    valueGreaterThan(value, min, name, units) {
      return value && value > min
        ? [true, null]
        : [false, `${name || 'Value'} must be greater than ${min} ${units || ''}`];
    },
    lengthBetween(value, min, max) {
      return value && value.length <= max && value.length >= min
        ? [true, null]
        : [false, `Length (${value.length}) must be between ${min} and ${max}`]
    },
    pattern(value, re, name) {
      return value && re.test(value) ? [true, null] : [false, `Improperly formatted ${name || 'value'}`];
    }
  }

  function change({ target }) {
    const field = target.closest('.field')
    if (field.dataset.type === 'time')
      updateTimeField(field)

    if (target[mutator])
      target[mutatorScope].split(' ').forEach(scope => mutate(scope, { entry: target, ctx: field }))

    validate(field)
  }

  function mutate(scope, ini) {
    const { entry, ctx } = ini
    if (!entry || !entry[mutatorScope]) throw new Error('Expected a mutation source')

    switch (scope) {
      case 'local':
        return _mutate(ctx, entry)
      case 'context':
        const ctxField = qs(`[data-for="${ctx.dataset.for}_context"]`, form)
        const dir = entry.type === 'radio' ? entry.value !== 'n/a' : entry.checked
        return toggle(ctxField, dir)
      default:
        return _mutate(qs(`[data-for="${scope}"]`), entry)
    }
  }

  function _mutate(ctx, src) {
    qsa('input:not([type=hidden])', ctx).forEach(node => node !== src && toggle(node, src.checked))
    manageError('remove', ctx)
    if (ctx !== src.closest('.field'))
      qs('.question', ctx).classList.toggle('required')
  }

  function toggle(node, dir) {
    node.tagName === 'INPUT' && (node.disabled = dir)

    switch (node.type) {
      case 'radio':
      case 'checkbox':
        node.checked = node.disabled ? false : node.checked
        break
      case 'number':
      case 'text':
        node.value = node.disabled ? '' : node.value
        break
      default:
        manageError('remove', node)
        node.classList[dir ? 'remove' : 'add']('hidden')
        !dir && (qs('input', node).value = '')
    }
  }

  function updateTimeField(field) {
    const hf = qs('[type=hidden]', field)
    const checks = qsa('[type=checkbox]', field).reduce((val, el) => el.checked && el.value || val, 0)

    if (checks) return hf.value = checks

    const fromMin = field.dataset.for === 'time'
    const lcv = [24, 60, 60, 1].slice(fromMin ? -2 : 0)
    const seconds = qsa('[type=number]', field)
      .map(v => +v.value)
      .reduce((a, b, i) => lcv[i] * (a + b), 0)

    return hf.value = Math.ceil(seconds * (fromMin ? 1 : 60))
  }

  function fillTime(value, field) {
    const explosion = explodeSeconds(value, field.dataset.for === 'time' ? 60 : 86400)
    qsa('[type=number]', field).forEach((el, i) => el.value = explosion[i])
  }

  function explodeSeconds(seconds, level) {
    const values = [Math.floor(seconds / level), seconds]
    if (level === 60) values[1] = seconds % 60
    else values[1] = values[0] ? Math.floor(seconds % 86400 / 3600) : +(seconds / 3600).toFixed(2)
    return values
  }

  function getValue(field) {
    if (qsa('input, textarea', field).length === qsa('input:disabled', field).length) return 'n/a'
    switch (field.dataset.type) {
      case 'time':
        return +qs('[type=hidden]', field).value || 0
      case 'text':
      case 'number':
        return qs('input, textarea', field).value
      default:
        const checked = qs('input:checked', field)
        return checked && checked.value
    }
  }

  function validate(field) {
    const checks = getValidators(field)
    if (!checks) return 0

    const fails = Object.keys(checks)
                        .map(key => validators[key](getValue(field), ...checks[key]))
                        .filter(v => !v[0])
    if (fails.length)
      manageError('add', field, fails[0][1])
    else
      manageError('remove', field)

    return fails.length
  }

  function validateAll() {
    return qsa('.field:not(.hidden)', form).map(validate).reduce((a, b) => a + b) < 1
  }

  function manageError(action, field, error = '') {
    field.classList[action]('validation-error')
    field.dataset.error = error
  }

  function getValidators(field) {
    const shouldValidate = (field.classList.contains('required') || !!qs('.question.required', field))
                           && !qs('input:disabled', field)
    if (!shouldValidate) return null

    const validators = { required: [] }
    if (~field.dataset.for.indexOf('context'))
      validators.lengthBetween = [5, 200]
    if (field.dataset.for === 'rid')
      validators.pattern = [/^A[A-Z0-9]{7,25}$/, 'requester ID']
    if (field.dataset.for === 'reward')
      validators.pattern = [/^(\d*(\.\d{0,2})?$)/, 'reward']
    if (field.dataset.type === 'time')
      validators.valueGreaterThan = [0, 'Time', 'seconds']
    return validators
  }

}())