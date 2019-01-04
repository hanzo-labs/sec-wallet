import El from 'el.js'
import { isRequired } from 'shop.js/src/containers/middleware'

import store from 'akasha'

class ActionRedeemForm extends El.Form
  tag: 'action-redeem'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  configs:
    'redeem.amount': [ isRequired ]

  bankOptions:
    0:
      title: 'First Demo Bank'
      subtitle: 'Account ending in 1234'

  tokenOptions:
    ust:
      title: 'Hanzo UST'
      subtitle: '1 ($1.00)'

  addressOptions: {}

  chosenBankIdx: 0

  step: 1

  init: ->
    @addressOptions =
      eth:
        img: '/img/eth-logo.svg'
        title: store.get 'ethAddress'
        subtitle: '1 ($1.00)'
      eos:
        img: '/img/eos-logo.png'
        title: store.get 'eosAddress'
        subtitle: '0 (0)'

    super arguments...

  getFiat: ->
    tokens = parseFloat @data.get('redeem.amount')
    if isNaN(tokens)
      return 0

    return tokens

  next: ->
    @step++
    @scheduleUpdate()

  back: ->
    @step--
    @scheduleUpdate()

  end: ->
    router.add "Account", "#account"

ActionRedeemForm.register()

export default ActionRedeemForm
