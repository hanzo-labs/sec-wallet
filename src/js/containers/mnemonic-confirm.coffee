import El from 'el.js'
import aes from 'aes-js'

import store from 'akasha'
import _ethers from 'ethers/dist/ethers'

import {
  isRequired
} from 'shop.js/src/containers/middleware'

ethers = _ethers.ethers

class MnemonicConfirm extends El.Form
  tag: 'mnemonic-confirm'
  html: '<yield></yield>'
  errorMessage: ''
  configs:
    'mnemonic.confirm': [ isRequired ]

  step: 1

  init: ->
    @newMnemonic()

    super arguments...

  getMnemonic: ->
    return @mnemonic

  resetStep: ->
    @step = 1
    @errorMessage = ''
    @scheduleUpdate()

  entryStep: ->
    @step = 2
    @errorMessage = ''
    @scheduleUpdate()

  newMnemonic: ->
    # @mnemonic = ethers.HDNode.entropyToMnemonic ethers.utils.randomBytes(16)
    @mnemonic = 'antique knee act powder leopard frame undo very true output lottery olympic'

  _submit: ->
    @errorMessage = ''

    @mnemonic2 = @data.get('mnemonic.confirm').toLowerCase().replace(/\s+/g,' ')

    if @mnemonic != @mnemonic2
      @errorMessage = 'Mnemonic does not match, please try again.'
      @scheduleUpdate()
      return

    # do the ctr encoding
    idHash = store.get 'i'
    key = ethers.utils.arrayify idHash

    # Convert text to bytes
    textBytes = aes.utils.utf8.toBytes(@mnemonic)

    # The counter is optional, and if omitted will begin at 1
    aesCtr = new (aes.ModeOfOperation.ctr)(key, new (aes.Counter)(5))
    encryptedBytes = aesCtr.encrypt(textBytes)

    # To print or store the binary data, you may convert it to hex
    pkEncoded = aes.utils.hex.fromBytes(encryptedBytes)

    store.set 'pk', pkEncoded

    El.update()

MnemonicConfirm.register()

export default MnemonicConfirm

