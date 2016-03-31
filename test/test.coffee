withContent = (content)->
  if $("#content").length == 0
    $('body').append('<div id="content"></div>')
  $("#content").html(content)
  # ActionCable.bindings.refresh()

test "it should create subscritions for action-cable-subscription elements in the dom", ->
  withContent """
    <action-cable-subscription channel="ChatChannel"></action-cable-subscription>
  """

  equal window.cable.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 1

  withContent ""
  equal window.cable.subscriptions.findAll("{\"channel\":\"ChatChannel\"}").length, 0

test "it should trigger events on the elements for messages received through the channel", ->
  withContent """
    <action-cable-subscription id='event-test' channel='ChatChannel'>
  """
  $('#event-test').on "cable:received", (e, data)->
    deepEqual data, {"message": "Hello"}

  window.cable.subscriptions.notify("{\"channel\":\"ChatChannel\"}","received", {"message": "Hello"})

test "it should perform actions when elements with data-cable-action attributes are clicked", ->
  withContent """
    <action-cable-subscription id='action-test' channel='ChatChannel'>
      <a data-cable-action='doAction'>Action</a>
    </action-cable-subscription>
  """

  subscription = window.cable.subscriptions.findAll("{\"channel\":\"ChatChannel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'

  $('[data-cable-action]').click()

test "it should perform actions when 'cable:perform' events are triggered on the element", ->
  withContent """
    <action-cable-subscription id='action-test' channel='ChatChannel'>
    </action-cable-subscription>
  """

  subscription = window.cable.subscriptions.findAll("{\"channel\":\"ChatChannel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'

  $('#action-test').trigger('cable:perform', 'doAction')


test "it should trigger events on the on the element that caused the subscription to be created", ->
  expect 2
  withContent """
    <action-cable-subscription id='test1' channel='RoomChannel'>
    </action-cable-subscription>
    <action-cable-subscription id='test2' channel='MentionChannel'>
    </action-cable-subscription>
  """
  $('#test1').on "cable:received", (e, data)->
    equal data, 1

  $('#test2').on "cable:received", (e, data)->
    equal data, 2

  window.cable.subscriptions.notify("{\"channel\":\"RoomChannel\"}","received", 1)
  window.cable.subscriptions.notify("{\"channel\":\"MentionChannel\"}","received", 2)

