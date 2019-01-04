import El from 'el.js'
import $ from 'zepto-modules/_min'

class PlaidWidget extends El.View
  tag: 'plaid'
  html: '<yield></yield>'

  handler: ->

  init: ->
    super arguments...
    $('<script></script>')
      .on('load', =>
        @handler = Plaid.create
          clientName: 'Plaid Quickstart'
          env: 'sandbox'
          key: 'bbd8fd9fc6f7801432b241ec2cee25'
          product: [ 'transactions' ]
          webhook: 'https://requestb.in'
          onLoad: ->
            # Optional, called when Link loads
            return
          onSuccess: (public_token, metadata) ->
            # Send the public_token to your app server.
            # The metadata object contains info about the institution the
            # user selected and the account ID or IDs, if the
            # Select Account view is enabled.
            $.post '/get_access_token', public_token: public_token
          onExit: (err, metadata) ->
            # The user exited the Link flow.
            if err != null
              # The user encountered a Plaid API error prior to exiting.
            else
            # metadata contains information about the institution
            # that the user selected and the most recent API request IDs.
            # Storing this information can be helpful for support.
          onEvent: (eventName, metadata) ->
            # Optionally capture Link flow events, streamed through
            # this callback as your users connect an Item to Plaid.
            # For example:
            # eventName = "TRANSITION_VIEW"
            # metadata  = {
            #   link_session_id: "123-abc",
            #   mfa_type:        "questions",
            #   timestamp:       "2017-09-14T14:42:19.350Z",
            #   view_name:       "MFA",
            # }
      ).attr('src', "https://cdn.plaid.com/link/v2/stable/link-initialize.js")
      .appendTo('body')
  addBank: ->
    @handler.open()

PlaidWidget.register()

export default PlaidWidget


