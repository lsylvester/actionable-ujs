# Actioncable::Bindings

Provides DOM bindings for [Action Cable](https://github.com/rails/actioncable) 

## Installation

This depends on Action Cable wich has not yet been released. You will need to add the Action Cable as a git dependency in addition to adding this gem to the Gemfile.

Add these lines to your application's Gemfile:

```ruby
gem 'actioncable', github: 'rails/actioncable'
gem 'actioncable-bindings'
```

And then execute:

    $ bundle

## Usage

Add cable_bindings to your `app/assets/javascripts/application.js` file after the jQuery require

```coffee
//= require jquery
//= require cable_bindings
```

Remove the `action_cable_meta_tag` from your `head`, and add a new `action-cable-connection` element to your `body`.

```html
<action-cable-connection url='/cable'>
```

If you are using turbolinks, add an `id and a `data-turbolinks-permanent` attribute so that a connection does not need to be reconnected whenever you change pages.

```html
<action-cable-connection url='/cable' id='cable' data-turbolinks-permanent>
```

Start creating subscriptions by adding `action-cable-subscription` elements with the channel attribute for the channel you want to subscribe to.

```html
<action-cable-subscription channel="ChatChannel">
  ...
</action-cable-subscription>
```

TODO: Allow passing in params when subscribing to a channel

Once you have created a subscription, the element will start triggering `cable:received` events whenever data is broadcast through the channel. You can subscribe to these events with something like

```coffee
$(document).on "cable:received", "#chat", (data)->
  # Do stuff with data
```

### Performing Actions

You can perform actions on a subscription by triggering the `cable:perform` event on the element.

```coffee
$('#my-subscribed-element').trigger("cable:perform", "myAction")
```

Any element with a `data-cable-perform` attribute will automatically perform the action in any parent element with a subscription when clicked.

For example,

```html
<action-cable-subscription channel="ChatChannel">
  <a data-cable-perform="away">Appear Away</a>
</action-cable-subscription>
```

will perform the `away` action on the `ChatChannel` subscription when the link is clicked.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec blade` and visit http://localhost:9876/ to run the javascript tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lsylvester/actioncable-bindings. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

