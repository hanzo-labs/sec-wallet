import El    from 'el.js'
import akasha from 'akasha'

import {
  isRequired
  isEmail
  splitName
  isStateRequired
  isPostalRequired
} from 'shop.js/src/containers/middleware'

class OnboardingKYCForm extends El.Form
  tag: 'onboarding-kyc'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  genderOpts:
    M: 'Male'
    F: 'Female'
    Other:       'Other'
    Unspecified: 'Unspecified'

  configs:
    'user.email':                     [ isRequired, isEmail ]
    'user.name':                      [ isRequired, splitName ]
    'user.metadata.phone':            [ isRequired ]
    'user.metadata.birthdate':        [ isRequired ]
    'user.metadata.gender':           [ isRequired ]

    'user.billingAddress.line1':      [ isRequired ]
    'user.billingAddress.line2':      null
    'user.billingAddress.city':       [ isRequired ]
    'user.billingAddress.state':      [ isStateRequired ]
    'user.billingAddress.postalCode': [ isPostalRequired ]
    'user.billingAddress.country':    [ isRequired ]

    'user.metadata.taxId':            [ isRequired ]

  init: ()->
    super arguments...

  _submit: ->
    opts =
      email:            @data.get 'user.email'
      firstName:        @data.get 'user.firstName'
      lastName:         @data.get 'user.lastName'
      billingAddress:   @data.get 'user.billingAddress'
      metadata:         @data.get 'user.metadata'

    opts.metadata.confirmed = true

    @errorMessage = ''

    @scheduleUpdate()
    @client.account.update(opts).then (res) =>
      @data.set 'user', res
      window.router.set 'KYC Demo - Confirmed', '#kyc-confirmed'
      @scheduleUpdate()
    .catch (err)=>
      @errorMessage = err.message
      @scheduleUpdate()

OnboardingKYCForm.register()

export default OnboardingKYCForm

