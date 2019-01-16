import ProfileForm from 'shop.js/src/containers/profile'
import Events from 'shop.js/src/events'
import contract from '../ustContract'
import aes from 'aes-js'

import store from 'akasha'
import _ethers from 'ethers/dist/ethers'

ethers = _ethers.ethers

class USTProfile extends ProfileForm
  tag: 'profile'
  hasPk: false
  mnemonic: ''
  decoded: false

  init: ->
    idHash = store.get 'i'
    pkEncoded = store.get 'pk'

    # idHash should be created by the login
    if !idHash
      @mediator.trigger Events.ProfileLoad
      @mediator.trigger Events.ProfileLoadFailed, new Error()
      return

    @hasPk = !!pkEncoded
    if @hasPk && !@decoded
      @decodePk()
      @decoded = true

    @on 'update', =>
      pkEncoded = store.get 'pk'
      @hasPk = !!pkEncoded
      if @hasPk && !@decoded
        @decodePk()
        @decoded = true

      if @decoded
        addr = store.get('ethAddress')
        contract.methods.balanceOf addr
          .call()
          .then (results) =>
            @data.set 'ethBalance', results
            @scheduleUpdate()
          .catch (err) ->
            console.log 'Error', err

      @scheduleUpdate()

    super arguments...

  logout: ->
    store.remove 'i'
    window.location.href = '/'

  decodePk: ->
    idHash = store.get 'i'
    pkEncoded = store.get 'pk'

    key = ethers.utils.arrayify idHash
    encryptedBytes = aes.utils.hex.toBytes(pkEncoded)

    # The counter mode of operation maintains internal state, so to
    # decrypt a new instance must be instantiated.
    aesCtr = new aes.ModeOfOperation.ctr(key, new aes.Counter(5))
    decryptedBytes = aesCtr.decrypt(encryptedBytes)

    # Convert our bytes back into text
    pk = aes.utils.utf8.fromBytes(decryptedBytes)

    eth = ethers.Wallet.fromMnemonic(pk, "m/44'/60'/0'/0/1").address
    eos = ethers.Wallet.fromMnemonic(pk, "m/44'/194'/0'/0/0").address.replace('0x', 'EOS')

    store.set 'ethAddress', eth
    store.set 'eosAddress', eos

USTProfile.register()
