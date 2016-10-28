(function data(rf) {
  'use strict';
  rf.data = rf.data || {
      pool: {
        title      : { validators: { required: [] } },
        reward     : { validators: { required: [], pattern: [/^(\d*(\.\d{0,2})?$)/, 'reward'] } },
        rname      : { validators: { required: [] } },
        rid        : {
          validators: {
            required         : [],
            lengthGreaterThan: [7],
            negPattern       : [/[^A-Z0-9]/, 'requester ID']
          }
        },
        comments   : { validators: {} },
        tos        : {
          title     : null,
          control   : {
            tag   : 'input',
            attrs : { type: 'checkbox' },
            labels: { class: 'question inline', desc: ['This HIT violates TOS'] },
            values: ['']
          },
          default   : 'false',
          validators: { required: [] }
        },
        broken     : {
          title     : null,
          control   : {
            tag   : 'input',
            attrs : { type: 'checkbox' },
            labels: { class: 'question inline', desc: ['This HIT is broken'] },
            values: ['']
          },
          default   : 'false',
          validators: { required: [] }
        },
        deceptive  : {
          title     : null,
          control   : {
            tag   : 'input',
            attrs : { type: 'checkbox' },
            labels: { class: 'question inline', desc: ['This HIT is deceptive'] },
            values: ['']
          },
          default   : 'false',
          validators: { required: [] }
        },
        detail     : {
          title     : null,
          control   : {
            tag   : 'input',
            attrs : { type: 'text', placeholder: 'Please explain', style: 'width:215px;' },
            labels: { class: '', desc: [null] },
            values: ['']
          },
          validators: { required: [], lengthGreaterThan: [5] }
        },
        completed  : {
          title     : 'How many HITs did you complete?',
          control   : {
            tag   : 'input',
            attrs : { type: 'radio' },
            labels: { class: 'inline', desc: ['None', 'One', 'More than one'] },
            values: ['none', 'one', 'multiple']
          },
          validators: { required: [] }
        },
        time       : {
          title     : 'Approximately how long did it take you to complete each HIT?',
          control   : {
            tag   : 'input',
            attrs : { type: 'number', step: '1', min: '0' },
            labels: { class: 'inline', desc: ['minutes', 'seconds'] },
            values: [null, null]
          },
          validators: { required: [], valueGreaterThan: [0, 'Time', 'seconds'] }
        },
        comm       : {
          title     : 'Was the requester communicative and responsive?',
          control   : {
            tag   : 'input',
            attrs : { type: 'radio' },
            labels: {
              class: 'block', desc: ['I did not contact the requester',
                                     'No, the requester did not respond to my satisfaction',
                                     'Yes, the requester responded to my satisfaction']
            },
            values: ['n/a', 'no', 'yes']
          },
          default   : 0,
          validators: { required: [] }
        },
        pending    : {
          title     : 'Is your work still pending approval?',
          control   : {
            tag   : 'input',
            attrs : { type: 'radio' },
            labels: {
              class: 'block', desc: ['Yes, all my work is pending',
                                     'Yes, some of my work is pending',
                                     'No, all my work has been approved/rejected']
            },
            values: ['all', 'some', 'none']
          },
          default   : 0,
          validators: { required: [] }
        },
        timePending: {
          title     : 'Approximately how long did it take to approve or reject?',
          control   : {
            tag   : 'input',
            attrs : { type: 'number', step: '1', min: '0' },
            labels: { class: 'inline', desc: ['days', 'hours'] },
            values: [null, null]
          },
          validators: { required: [], valueGreaterThan: [10, 'Time', 'seconds'] }
        },
        rejected   : {
          title     : 'Was your work rejected?',
          control   : {
            tag   : 'input',
            attrs : { type: 'radio' },
            labels: {
              class: 'block', desc: ['No, none of my work was rejected',
                                     'Yes, some or all of my work was rejected',
                                     'Yes, but the rejection(s) were overturned']
            },
            values: ['no', 'yes', 'overturned']
          },
          default   : 0,
          validators: { required: [] }
        },
        recommend  : {
          title     : 'Would you recommend this HIT to others?',
          control   : {
            tag   : 'input',
            attrs : { type: 'radio' },
            labels: { class: 'inline', desc: ['No opinion', 'No', 'Yes'] },
            values: ['n/a', 'no', 'yes']
          },
          default   : 0,
          validators: { required: [] }
        }
      },
      tree: {
        tos      : {
          children: ['detail'],
          as      : ['tosDetail'],
          add     : { if: ['true'] },
          remove  : { if: ['false'] }
        },
        broken   : {
          children: ['detail'],
          as      : ['brokenDetail'],
          add     : { if: ['true'] },
          remove  : { if: ['false'] }
        },
        deceptive: {
          children: ['detail'],
          as      : ['deceptiveDetail'],
          add     : { if: ['true'] },
          remove  : { if: ['false'] }
        },
        completed: {
          children: ['time', 'comm', 'pending', 'recommend'],
          add     : { if: ['one', 'multiple'] },
          remove  : { grandchildren: ['timePending', 'rejected'], if: ['none'] }
        },
        pending  : {
          children: ['timePending', 'rejected'],
          add     : { if: ['some', 'none'] },
          remove  : { if: ['all'] }
        },
        recommend: {
          children: ['detail'],
          as      : ['recommendDetail'],
          add     : { if: ['yes', 'no'] },
          remove  : { if: ['n/a'] }
        }
      }
    };
})(window._rf || (window._rf = {}));
