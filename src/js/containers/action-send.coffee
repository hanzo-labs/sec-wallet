import El from 'el.js'
import { isRequired } from 'shop.js/src/containers/middleware'

import store from 'akasha'

class ActionSendForm extends El.Form
  tag: 'action-send'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  configs:
    'send.destinationAddress': [ isRequired ]
    'send.amount':             [ isRequired ]

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

  getTokens: ->
    tokens = parseFloat @data.get('send.amount')
    if isNaN(tokens)
      return 0

    return tokens / 100

  next: ->
    @step++
    @scheduleUpdate()

  back: ->
    @step--
    @scheduleUpdate()

  end: ->
    router.add "Account", "#account"

ActionSendForm.register()

export default ActionSendForm
