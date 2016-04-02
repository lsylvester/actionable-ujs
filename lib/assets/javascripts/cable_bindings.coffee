#= require action_cable

@cable  = ActionCable.createConsumer()


class @ActionCableSubscription extends HTMLElement
    
  attachedCallback: ->
    if @unsubscriber
      cancelAnimationFrame(@unsubscriber)
    else
      subscriptionParams = @getAttribute('params')
      if subscriptionParams
        subscriptionOptions = JSON.parse(subscriptionParams)
        subscriptionOptions.channel = @getAttribute('channel')
      else
        subscriptionOptions = {channel: @getAttribute('channel')}
      @subscription = cable.subscriptions.create subscriptionOptions,
        received: (data)=>
          $(this).trigger("cable:received", data)
      $(this).on 'cable:perform', (e, action, params)=>
        @subscription.perform action, params

  detachedCallback: ->
    @unsubscriber = requestAnimationFrame =>
      @subscription.unsubscribe()
      
document.registerElement 'action-cable-subscription', ActionCableSubscription


$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')
