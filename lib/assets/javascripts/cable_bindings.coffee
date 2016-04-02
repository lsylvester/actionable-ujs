#= require action_cable

class @ActionCableConnection extends HTMLElement
  attachedCallback: ->
    if @disconector
      cancelAnimationFrame(@disconector)
    else
      @cable = ActionCable.createConsumer(@getAttribute('url'))


  detachedCallback: ->
    @disconector = requestAnimationFrame =>
      @cable.disconnect()

document.registerElement 'action-cable-connection', ActionCableConnection

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
      cable = document.querySelector('action-cable-connection').cable
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
