import El from 'el.js'
import { isRequired } from 'shop.js/src/containers/middleware'

class SendForm extends El.Form
  tag: 'send'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  configs:
    'sendAmount':  [ isRequired ]
    'sendAddress': [ isRequired ]

SendForm.register()

export default SendForm

