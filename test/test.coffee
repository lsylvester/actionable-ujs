withContent = (content)->
  if $("#content").length == 0
    $('body').append('<div id="content"></div>')
  $("#content").html(content)
  $(document).trigger("page:change")

test "the consumer reads the url from the meta tag", ->
  equal "ws://localhost:28080", Cable.boundConsumer.url,

test "it should create subscritions for data-cable-subscribe attributes in the dom", ->
  withContent """
    <div data-cable-subscribe='ChatChannel'></div>
  """

  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 1

  withContent ""
  equal Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 0

test "it should trigger events on the elements for messages received through the channel", ->
  withContent """
    <div id='event-test' data-cable-subscribe='ChatChannel'>
    </div>
  """
  $('#event-test').on "cable:received", (e, data)->
    deepEqual data, {"message": "Hello"}

  Cable.boundConsumer.subscriptions.notify("{\"channel\":\"ChatChannel\"}","received", {"message": "Hello"})

test "it should perform actions when elements with data-cable-action attributes are clicked", ->
  withContent """
    <div id='action-test' data-cable-subscribe='ChatChannel'>
      <a data-cable-action='doAction'>Action</a>
    </div>
  """

  subscription = Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'

  $('[data-cable-action]').click()

test "it should perform actions when 'cable:perform' events are triggered on the element", ->
  withContent """
    <div id='action-test' data-cable-subscribe='ChatChannel'>
    </div>
  """

  subscription = Cable.boundConsumer.subscriptions.findAll("{\"channel\":\"ChatChannel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'

  $('#action-test').trigger('cable:perform', 'doAction')


