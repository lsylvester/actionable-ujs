
test "the consumer reads the url from the meta tag", ->
  equal "ws://localhost:28080", Cable.boundConsumer.url,

test "it should create subscritions for data-cable-subscribe attributes in the dom", ->
  $('body').append("<div data-cable-subscribe='ChatChannel'></div>")
  $(document).trigger("page:change")

  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 1

  $("[data-cable-subscribe=ChatChannel]").remove()
  $(document).trigger("page:change")

  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 0

test "it should trigger events on the elements for messages received through the channel", ->
  $('body').append("<div id='event-test' data-cable-subscribe='ChatChannel'></div>")
  $(document).trigger("page:change")
  $('#event-test').on "cable:received", (e, data)->
    deepEqual data, {"message": "Hello"}
    $('#event-test').remove()

  Cable.boundConsumer.subscriptions.notify("{\"channel\":\"ChatChannel\"}","received", {"message": "Hello"})

test "it should perform actions on the elements for messages received through the channel", ->
  $('body').append("<div id='action-test' data-cable-subscribe='ChatChannel'><a data-cable-action='doAction'>Action</a></div>")
  $(document).trigger("page:change")

  subscription = Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'
    $('#action-test').remove()

  $('[data-cable-action]').click()
