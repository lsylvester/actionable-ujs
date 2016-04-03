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

        # Called when the subscription is ready for use on the server
        connected: =>
          @setAttribute("state", "connected")
          $(this).trigger("cable:connected")

        # Called when the WebSocket connection is closed
        disconnected: =>
          @setAttribute("state", "disconnected")
          $(this).trigger("cable:disconnected")

        # Called when the subscription is rejected by the server
        rejected: =>
          @setAttribute("state", "rejected")
          $(this).trigger("cable:rejected")

      $(this).on 'cable:perform', (e, action, params)=>
        @subscription.perform action, params

  detachedCallback: ->
    @unsubscriber = requestAnimationFrame =>
      @subscription.unsubscribe()
      
document.registerElement 'action-cable-subscription', ActionCableSubscription


$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')
