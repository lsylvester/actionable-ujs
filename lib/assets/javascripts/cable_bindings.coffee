#= require action_cable

@cable  = ActionCable.createConsumer()


class @ActionCableSubscription extends HTMLElement
    
  attachedCallback: ->
    @subscription = cable.subscriptions.create channel: @getAttribute('Channel'),
      received: (data)=>
        $(this).trigger("cable:received", data)
    
    $(this).on 'cable:perform', (e, action, params)=>
      console.log(this, @subscription)
      @subscription.perform action, params

  detachedCallback: ->
    @subscription.unsubscribe()

document.registerElement 'action-cable-subscription', ActionCableSubscription


$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')
