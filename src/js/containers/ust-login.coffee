import LoginForm from 'shop.js/src/containers/login'
import Events from 'shop.js/src/events'

import store from 'akasha'
import _ethers from 'ethers/dist/ethers'

ethers = _ethers.ethers

class USTLogin extends LoginForm
  tag: 'login'

  init: ->
    super arguments...

  _submit: (event) ->
    opts =
      email:    @data.get 'user.email'
      password: @data.get 'user.password'

    @errorMessage = ''

    @scheduleUpdate()
    @mediator.trigger Events.Login
    @client.account.login(opts).then (res) =>
      i = @data.get('user.email') + @data.get('user.password')
      store.set 'i', ethers.utils.sha256(ethers.utils.toUtf8Bytes(i))

      @mediator.trigger Events.LoginSuccess, res
      @scheduleUpdate()
    .catch (err)=>
      @errorMessage = err.message
      @mediator.trigger Events.LoginFailed, err
      @scheduleUpdate()

USTLogin.register()
