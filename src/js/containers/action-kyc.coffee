import El from 'el.js'
import akasha from 'akasha'

import {
  isRequired
  isEmail
  isStateRequired
  isPostalRequired
} from 'shop.js/src/containers/middleware'

import store from 'akasha'

class ActionKYCForm extends El.Form
  tag: 'action-kyc'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  submitted: false

  genderOpts:
    M: 'Male'
    F: 'Female'
    Other:       'Other'
    Unspecified: 'Unspecified'

  configs:
    'user.email':                   [ isRequired, isEmail ]
    'user.firstName':               [ isRequired ]
    'user.lastName':                [ isRequired ]
    'user.kyc.phone':               [ isRequired ]
    'user.kyc.birthdate':           [ isRequired ]
    'user.kyc.gender':              [ isRequired ]

    'user.kyc.address.name':        [ isRequired ]
    'user.kyc.address.line1':       [ isRequired ]
    'user.kyc.address.line2':       null
    'user.kyc.address.city':        [ isRequired ]
    'user.kyc.address.state':       [ isStateRequired ]
    'user.kyc.address.postalCode':  [ isPostalRequired ]
    'user.kyc.address.country':     [ isRequired ]

    'user.kyc.taxId':               [ isRequired ]

  init: ()->
    super arguments...

  _submit: ->
    opts =
      email:       @data.get 'user.email'
      firstName:   @data.get 'user.firstName'
      lastName:    @data.get 'user.lastName'
      kyc:         @data.get 'user.kyc'

    opts.kyc.status = 'initiated'

    @errorMessage = ''

    @scheduleUpdate()
    @client.account.update(opts).then (res) =>
      @data.set 'user', res
      @submitted = true
      @scheduleUpdate()
    .catch (err)=>
      @errorMessage = err.message
      @scheduleUpdate()

  end: ->
    router.add "Account", "#account"
    return false

ActionKYCForm.register()

export default ActionKYCForm
