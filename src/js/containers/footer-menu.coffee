import El from 'el.js'

class FooterMenu extends El.View
  tag: 'footer-menu'
  html: '<yield></yield>'

  init: ->
    super arguments...

    # get KYC status from smart contract

  isPage: (page)->
    return router.get().page == ('#' + page)

  deposit: ->
    if true ||  @data.get 'opts.kyc.status'
      router.add "Deposit", "#deposit"
    else
      router.add "KYC/AML", "#kyc"

  send: ->
    if true ||  @data.get 'opts.kyc.status'
      router.add "Send", "#send"
    else
      router.add "KYC/AML", "#kyc"

  redeem: ->
    if true || @data.get 'opts.kyc.status'
      router.add "Redeem", "#redeem"
    else
      router.add "KYC/AML", "#kyc"

FooterMenu.register()

export default FooterMenu

