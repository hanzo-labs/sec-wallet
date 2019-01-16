import moment from 'moment-timezone'

import './controls/picker'
import './controls/webcam-picture'

import './containers/onboarding-kyc'
import './containers/plaid'
import './containers/ust-login'
import './containers/ust-register'
import './containers/ust-profile'
import './containers/action-deposit'
import './containers/action-send'
import './containers/action-redeem'
import './containers/action-kyc'
import './containers/mnemonic-confirm'
import './containers/footer-menu'

import Coin from 'coin.js/src'
import Router from './router'
import store from 'akasha'
import { HANZO_KEY, HANZO_ENDPOINT, ETH_CONTRACT_ADDRESS, ETH_NODE } from './constants'

# services
import { updateBalance } from './services'

window.router = r = new Router

window.logout = ->
  Coin.client.account.logout()
  document.location.href = '/login'

window.currencyOpts =
  usd: 'USD'

window.tokenOpts =
  ust: 'UST'
  uscabbt: 'USCABBT'
  sdrt: 'SDRT'

window.sortOrders = (orders) ->
  orders.sort (a, b) ->
    return moment(b.createdAt).diff moment(a.createdAt)

window.accountRegister = ->
  window.location.href = '/signup'
  return false

window.accountLogin = ->
  window.location.href = '/'
  return false

Coin.start
  key:       HANZO_KEY
  endpoint:  HANZO_ENDPOINT
  processor: 'ethereum'
  currency:  'eth'
  mode: 'deposit'
  order:
    subtotal:  1e9
  eth:
    address: ETH_CONTRACT_ADDRESS
    node:    ETH_NODE

data = Coin.getData()

data.set 'ui.currency', 'usd'

m = Coin.getMediator()

m.on 'login-success', ->
  document.location.href = '/account'
  r.set 'Account', '#account'

m.on 'register-success', ->
  document.location.href = '/account'
  r.set 'Account', '#account'

m.on 'profile-load-success', ->
  if !r.get() || !r.get().page
    r.set 'Account', '#account'

  country = data.get 'user.billingAddress.country'
  if !country
    data.set 'user.billingAddress.country', 'US'

m.on 'profile-load-failed', ->
  Coin.client.account.logout()
  document.location.href = '/'

r.onUpdate = ->
  Coin.El.scheduleUpdate()
  # if r.get().page == '#kyc' && data.get('user.metadata.confirmed')
  #   window.router.set 'Deposit', '#deposit'
  #   Coin.El.update()

# m.on 'submit-success', ->
#   @client.account.get().then (res) =>
#     @data.set 'user', res
#     firstName = @data.get 'user.firstName'
#     lastName = @data.get 'user.lastName'
#     @data.set 'user.name', firstName + ' ' + lastName

#     Coin.El.scheduleUpdate()

updateBalance(data, Coin.El.scheduleUpdate)

