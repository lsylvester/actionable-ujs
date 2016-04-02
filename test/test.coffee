withContent = (content)->
  if $("#content").length == 0
    $('body').append('<div id="content"></div>')
  $("#content").html(content)
  # ActionCable.bindings.refresh()

test "it should create subscritions for action-cable-subscription elements in the dom", 2, (assert)->
  withContent """
    <action-cable-subscription channel="Chat5Channel"></action-cable-subscription>
  """
  equal document.querySelector('action-cable-connection').cable.subscriptions.findAll("{\"channel\":\"Chat5Channel\"}").length, 1

  withContent ""
  done = assert.async()
  requestAnimationFrame(->
    equal document.querySelector('action-cable-connection').cable.subscriptions.findAll("{\"channel\":\"Chat5Channel\"}").length, 0
    done()
  ,100)

test "it should trigger events on the elements for messages received through the channel", ->
  withContent """
    <action-cable-subscription id='event-test' channel='Chat4Channel'>
  """
  $('#event-test').on "cable:received", (e, data)->
    deepEqual data, {"message": "Hello"}

  document.querySelector('action-cable-connection').cable.subscriptions.notify("{\"channel\":\"Chat4Channel\"}","received", {"message": "Hello"})

test "it should perform actions when elements with data-cable-action attributes are clicked", ->
  withContent """
    <action-cable-subscription id='action-test' channel='Chat3Channel'>
      <a data-cable-action='doAction'>Action</a>
    </action-cable-subscription>
  """

  subscription = document.querySelector('action-cable-connection').cable.subscriptions.findAll("{\"channel\":\"Chat3Channel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'

  $('[data-cable-action]').click()

test "it should perform actions when 'cable:perform' events are triggered on the element", (assert)->
  done = assert.async()
  withContent """
    <action-cable-subscription id='action-test' channel='Chat2Channel'>
    </action-cable-subscription>
  """

  subscription = document.querySelector('action-cable-connection').cable.subscriptions.findAll("{\"channel\":\"Chat2Channel\"}")[0]
  subscription.perform = (action, data)->
    equal action, 'doAction'
    done()

  $('#action-test').trigger('cable:perform', 'doAction')


test "it should trigger events on the on the element that caused the subscription to be created", ->
  expect 2
  withContent """
    <action-cable-subscription id='test1' channel='Room1Channel'>
    </action-cable-subscription>
    <action-cable-subscription id='test2' channel='Mention1Channel'>
    </action-cable-subscription>
  """
  $('#test1').on "cable:received", (e, data)->
    equal data, 1

  $('#test2').on "cable:received", (e, data)->
    equal data, 2

  document.querySelector('action-cable-connection').cable.subscriptions.notify("{\"channel\":\"Room1Channel\"}","received", 1)
  document.querySelector('action-cable-connection').cable.subscriptions.notify("{\"channel\":\"Mention1Channel\"}","received", 2)

