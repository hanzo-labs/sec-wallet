import El from 'el.js'
import { isRequired } from 'shop.js/src/containers/middleware'

class WithdrawForm extends El.Form
  tag: 'withdraw'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  configs:
    'withdrawAmount': [ isRequired ]

WithdrawForm.register()

export default WithdrawForm
