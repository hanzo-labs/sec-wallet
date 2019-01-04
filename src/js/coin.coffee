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
  key:       'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzIsImp0aSI6Im8yVEtwTUJRRERVIiwic3ViIjoiVjFRVFp4RFM2ViJ9.OUApzGKj5Y2mFVpaRPFfMAUMQM1-0NEAODDvTCGGeJJlBNbHKQ-8cjJ2i7qIpjCtAa_ZG6-iO6LlHKenAVGyxQ'
  endpoint:  'http://localhost:8081'
  processor: 'ethereum'
  currency:  'eth'
  mode: 'deposit'
  order:
    subtotal:  1e9
  eth:
    address: '0x945f873d71b0f497d71a05d25c7bf5e7547ab826'
    node:    '//api.infura.io/v1/jsonrpc/ropsten'

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
#
