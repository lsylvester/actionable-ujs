class ActionCableSubscriptionElement extends HTMLElement

  getSubscriptionOptions: ->
    subscriptionParams = @getAttribute('params')
    if subscriptionParams
      subscriptionOptions = JSON.parse(subscriptionParams)
      subscriptionOptions.channel = @getAttribute('channel')
    else
      subscriptionOptions = {channel: @getAttribute('channel')}
    subscriptionOptions
  
  received: (data)->
    @trigger("cable:received", data)
  
  setState: (state)->
    @setAttribute("state", state)
    @trigger("cable:#{state}")
  
  trigger: (eventName, data={})->
    event = document.createEvent("Events")
    event.initEvent(eventName, true, true)
    event.data = data ? {}
    @dispatchEvent(event)
    event
  
  connected: -> @setState("connected")

  disconnected: -> @setState("disconnected")
    
  rejected: -> @setState("rejected")

  getCable: -> 
    cableName = @getAttribute("cable")
    if cableName
      document.querySelector("action-cable-connection[name='#{cableName}']").cable
    else    
      document.querySelector('action-cable-connection:not([name])').cable
    
  createSubscription: ->
    @subscription = @getCable().subscriptions.create @getSubscriptionOptions(),
      received: (data)=> @received(data)
      connected: => @connected()
      disconnected: => @disconnected()
      rejected: => @rejected()
    
  perform: (action, params)->
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
      
document.registerElement 'action-cable-subscription', ActionCableSubscriptionElement
