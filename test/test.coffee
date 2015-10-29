test "the consumer reads the url from the meta tag", ->
  equal "ws://localhost:28080", Cable.boundConsumer.url,

test "it should create subscritions for data-cable-subscribe attributes in the dom", ->
  $('body').append("<div data-cable-subscribe='ChatChannel'></div>")
  $(document).trigger("page:change")

  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 1

  $("[data-cable-subscribe=ChatChannel]").remove()
  $(document).trigger("page:change")

  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 0
