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

  getSubscriptionOptions: ->
    subscriptionParams = @getAttribute('params')
    if subscriptionParams
      subscriptionOptions = JSON.parse(subscriptionParams)
      subscriptionOptions.channel = @getAttribute('channel')
    else
      subscriptionOptions = {channel: @getAttribute('channel')}
    subscriptionOptions
  
  received: (data)->
    $(this).trigger("cable:received", data)
  
  setState: (state)->
    @setAttribute("state", state)
    $(this).trigger("cable:#{state}")
  
  connected: -> @setState("connected")

  disconnected: -> @setState("disconnected")
    
  rejected: -> @setState("rejected")

  getCable: -> document.querySelector('action-cable-connection').cable
    
  createSubscription: ->
    @subscription = @getCable().subscriptions.create @getSubscriptionOptions(),
      received: (data)=> @received(data)
      connected: => @connected()
      disconnected: => @disconnected()
      rejected: => @rejected()

  createdCallback: ->
    $(this).on 'cable:perform', (e, action, params)=>
      @subscription?.perform action, params

  attachedCallback: ->
    if @unsubscriber
      cancelAnimationFrame(@unsubscriber)
    else
      @createSubscription()

  detachedCallback: ->
    @unsubscriber = requestAnimationFrame =>
      @subscription.unsubscribe()
      @subscription = null
      
document.registerElement 'action-cable-subscription', ActionCableSubscription


$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')
