# Actioncable::Bindings

WARNING: This is a work in progress and is currently incomplete. It is not ready for use.

Provides DOM bindings for [Action Cable](https://github.com/rails/actioncable) 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'actioncable-bindings'
```

And then execute:

    $ bundle

## Usage

Add cable_bindings to your `app/assets/javascripts/application.js` file.

    //= require cable_bindings

Add a cable metatag to point to your Action Cable server

    <meta name="cable-uri" value="ws://localhost:28080">

Then, start creating subscriptions by adding `data-cable-subscribe` attributes your tags, with the value being the name of the channel you want to subscribe to.


    <div data-cable-subscribe="ChatChannel">
      ...
    </div>

You can also create a subscribion using extra parameters by JSON encoding a object.

    <div data-cable-subscribe="{&quot;channel&quote;: &quote;ChatChannel&quote;, &quot;room&quote;: &quote;Best Room&quote;}">
      ...
    </div>

Once you have created a subscription, the element will start triggering `cable:received` events whenever data is broadcast through the channel. You can subscribe to these events with something like

    $(document).on "cabel:received", "#chat", (data)->
      # Do stuff with data

### Performing Actions

You can perform actions on subscriptions that you have made by triggering events on the elements. To perform a action on a subscription trigger the `cable:perform` events, passing in the action name as the first parameter. Additional data can be passed in through the second parameter.

    $("#chat").trigger('cable:perform', "appearOn", "Some Room")

You can add `data-cabel-perform` attributes to elements within the subscription element to automatically trigger `cable:perform` events.

A `a` or `button` element with `data-cable-perform` with perform the action when clicked.

    <a data-cable-perform="away">Appear Away</a>

A  `form` element will trigger perform the action when it is submitted, and `input`, `textarea` or  `select` element will trigger the event on change.

You can change the event that triggers the action using the `data-cable-on` attribute. Any element with `data-cable-on` can trigger actions on the parent attribute.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lsylvester/actioncable-bindings. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

