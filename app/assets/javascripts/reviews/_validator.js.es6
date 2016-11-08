(function (rf) {
  rf.validator = rf.validator || {
      required         : _required,
      pattern          : _pattern,
      lengthGreaterThan: _lenGT,
      lengthBetween    : _lenIn,
      valueGreaterThan : _valGT,
      negPattern       : _negPattern
    };

  function _required(value) {
    return value !== null && value !== undefined && value.toString().length > 0 ? [true, null] : [false, 'Required'];
  }

  function _valGT(value, min, name, units) {
    return value && value > min
      ? [true, null]
      : [false, `${name || 'Value'} must be greater than ${min} ${units || ''}`];
  }

  function _lenGT(value, min) {
    return value && value.length > min ? [true, null] : [false, `Length must be greater than ${min}`];
  }

  function _lenIn(value, min, max) {
    return value && value.length <= max && value.length >= min
      ? [true, null]
      : [false, `Length (${value.length}) must be between ${min} and ${max}`]
  }

  function _lenLT(value, max) {
    return value && value.length > max ? [true, null] : [false, `Length must be less than ${max}`];
  }

  function _negPattern(value, re, name) {
    return value && re.test(value) ? [false, `Improperly formatted ${name || 'value'}`] : [true, null];
  }

  function _pattern(value, re, name) {
    return value && re.test(value) ? [true, null] : [false, `Improperly formatted ${name || 'value'}`];
  }
})(window._rf);