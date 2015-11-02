#= require cable

setupConnection = ->
  Cable.boundConsumer = Cable.createConsumer $('meta[name=cable-uri]').attr('value')

setupSubscriptions = ->
  for subscription in Cable.boundConsumer.subscriptions.subscriptions
    if subscription.element and !$.contains(document, subscription.element)
      subscription.unsubscribe()

  for element in $('[data-cable-subscribe]')
    element.subscription ||= Cable.boundConsumer.subscriptions.create $(element).data('cable-subscribe'),
      element: element,

      received: (data)->
        $(element).trigger("cable:received", data)

      connected: ->
        $(element).trigger("cable:connected")

    $(element).on 'cable:perform', (e, action, params)->
      element.subscription.perform action, params

$(document).on 'click', "[data-cable-action]", (e)->
  $(this).trigger 'cable:perform', $(this).data('cable-action')

$(document).ready setupConnection
$(document).on "page:change", setupSubscriptions
