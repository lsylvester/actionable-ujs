#= require cable

class Bindings
  setupConsumer: =>
    @consumer = Cable.createConsumer $('meta[name=cable-uri]').attr('value')

  refresh: =>
    for subscription in @consumer.subscriptions.subscriptions
      if subscription.element and !$.contains(document, subscription.element)
        subscription.unsubscribe()

    @buildSubscription(element) for element in $('[data-cable-subscribe]')

  buildSubscription: (element)=>
    element.subscription ||= @consumer.subscriptions.create $(element).data('cable-subscribe'),
      element: element,

      received: (data)->
        $(element).trigger("cable:received", data)

      connected: ->
        $(element).trigger("cable:connected")

    $(element).on 'cable:perform', (e, action, params)->
      element.subscription.perform action, params

Cable.bindings = new Bindings

$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')

$(document).ready Cable.bindings.setupConsumer
$(document).on "page:change", Cable.bindings.refresh
