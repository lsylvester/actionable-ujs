# Roadmap
* [ ] Allow creating multiple connections. and allow a subscription to pick the connection based on its name
  
    <action-cable-connection url='/special/cable' name='special'>

    <action-cable-subscription connection='special' ...>

* [ ] Add state attributes to cables and subscriptions to allow easy detection of disconnects
* [ ] Support updating subscriptions/connections when the attributes change.
* [ ] Make forms perform actions on submit instead of click
* [ ] Allow events that perform actions to be customized with `data-cable-on` attributes.
* [ ] Restrict `data-cable-action` click to elements that click would normally trigger events (like `a` tags)
* [ ] Support `data-cable-action` in input, textarea, select ect, with default action on change
