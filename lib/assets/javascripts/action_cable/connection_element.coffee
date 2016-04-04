class ActionCableConnectionElement extends HTMLElement
  attachedCallback: ->
    if @disconector
      cancelAnimationFrame(@disconector)
    else
      @cable = ActionCable.createConsumer(@getAttribute('url'))


  detachedCallback: ->
    @disconector = requestAnimationFrame =>
      @cable?.disconnect()

document.registerElement 'action-cable-connection', ActionCableConnectionElement
