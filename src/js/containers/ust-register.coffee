import RegisterForm from 'shop.js/src/containers/register'
import Events from 'shop.js/src/events'

import store from 'akasha'
import _ethers from 'ethers/dist/ethers'

ethers = _ethers.ethers

import {
  agreeToTerms
} from 'shop.js/src/containers/middleware'

class USTRegister extends RegisterForm
  tag: 'register'

  init: ->
    @configs['user.over18'] = [ agreeToTerms ]

    super arguments...

  _submit: (event) ->
    opts =
      email:           @data.get 'user.email'
      firstName:       @data.get 'user.firstName'
      lastName:        @data.get 'user.lastName'
      formId:          @formId
      password:        @data.get 'user.password'
      passwordConfirm: @data.get 'user.passwordConfirm'
      referrerId:      @data.get 'order.referrerId'
      isAffiliate:     !!@affiliateSignup
      metadata:
        source: @source

    # only add username if its not null
    username = @data.get 'user.username'
    if username?
      opts.username = username

    #optional captcha
    captcha = @data.get 'user.g-recaptcha-response'
    if captcha
      opts['g-recaptcha-response'] = captcha

    @errorMessage = ''

    @scheduleUpdate()
    @mediator.trigger Events.Register
    @client.account.create(opts).then (res) =>
      i = @data.get('user.email') + @data.get('user.password')
      store.set 'i', ethers.utils.sha256(ethers.utils.toUtf8Bytes(i))
      store.remove 'pk'

      @mediator.trigger Events.RegisterSuccess, res
      @scheduleUpdate()

      if @immediateLogin && res.token
        @client.setCustomerToken res.token
        latency = @immediateLoginLatency / 2
        # simulate login with a little bit of latency for page transitions
        setTimeout =>
          @mediator.trigger Events.Login
          setTimeout =>
            @mediator.trigger Events.LoginSuccess, res
            @scheduleUpdate()
          , latency
        , latency
    .catch (err) =>
      @errorMessage = err.message
      @mediator.trigger Events.RegisterFailed, err
      @scheduleUpdate()

USTRegister.register()
