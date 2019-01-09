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
      subtitle: '2,825.40 ($2,825.40)'

  addressOptions: {}

  chosenBankIdx: 0

  step: 1

  init: ->
    @addressOptions =
      eth:
        img: '/img/eth-logo.svg'
        title: store.get 'ethAddress'
        subtitle: '2149.40 ($2149.40)'
      eos:
        img: '/img/eos-logo.png'
        title: store.get 'eosAddress'
        subtitle: '676.00 (676.00)'

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
