import El from 'el.js'
import { isRequired } from 'shop.js/src/containers/middleware'

import store from 'akasha'

class ActionDepositForm extends El.Form
  tag: 'action-deposit'
  html: '<form onsubmit="{ submit }"><yield></yield></form>'

  configs:
    'deposit.amount': [ isRequired ]

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
        subtitle: '...'
      eos:
        img: '/img/eos-logo.png'
        title: store.get 'eosAddress'
        subtitle: '676.00 (676.00)'

    @on 'update', =>
      amount = @renderCurrency 'usd', @data.get('ethBalance')
      @addressOptions.eth.subtitle = amount.substr(1) + ' (' + amount + ')'

    super arguments...

  getTokens: ->
    tokens = parseFloat @data.get('deposit.amount')
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

ActionDepositForm.register()

export default ActionDepositForm
