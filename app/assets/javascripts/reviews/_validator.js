(function (rf) {
  rf.validator = rf.validator || {
      required         : _required,
      pattern          : _pattern,
      lengthGreaterThan: _lenGT,
      valueGreaterThan : _valGT,
      negPattern       : _negPattern
    };

  function _required(value) {
    return value !== null && value.length > 0 ? [true, null] : [false, 'Required'];
  }

  //function _length(value, range) {
  //  if (range.length === 1)
  //    return value.length === range[0]
  //      ? [true, null] : [false, `Length must be ${range[0]}`];
  //  else
  //    return value.length >= range[0] && value.length <= range[1]
  //      ? [true, null] : [false, `Length must be at least ${range[0]}`]
  //}

  function _valGT(value, min, name, units) {
    return value > min
      ? [true, null]
      : [false, `${name || 'Value'} must be greater than ${min} ${units || ''}`];
  }

  function _lenGT(value, min) {
    return value.length > min ? [true, null] : [false, `Length must be greater than ${min}`];
  }

  function _lenLT(value, max) {
    return value.length > max ? [true, null] : [false, `Length must be less than ${max}`];
  }

  function _negPattern(value, re, name) {
    return re.test(value) ? [false, `Improperly formatted ${name || 'value'}`] : [true, null];
  }

  function _pattern(value, re, name) {
    return re.test(value) ? [true, null] : [false, `Improperly formatted ${name || 'value'}`];
  }
})(window._rf);