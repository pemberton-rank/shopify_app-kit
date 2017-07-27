# Kit integration for Shopify App

If you own a Shopify App, and would like to integrate it into Kit by creating conversation for user, you can use this gem to handle all the common logic for handling Kit conversation.

It lets you

- Connect Kit Account to user
- Send Kit conversation to a user
- Receive reply from a user

## Installation and Setup

We are assuming that your app is either made using our https://github.com/pemberton-rank/react-shopify-app template or at least use a token authentication that is provided by `pr-common` gem.

1. Add next lines to your to your Gemfile

```ruby
gem 'shopify_app-kit', github: 'pemberton-rank/shopify_app-kit'
gem 'omniauth-kit-oauth2', github: 'pemberton-rank/omniauth-kit-oauth2'
gem 'pr-common', git: 'https://github.com/pemberton-rank/common.git', tag: 'v0.1.6' # :path => '../common'
```

2. Run `bundle exec rails g migration add_kit_access_token_to_users kit_access_token kit_user_id first_name last_name` to add some Kit-related fields

3. Create `config/initializers/kit.rb` and put next lines there

```ruby
ShopifyApp::Kit.configure do |config|
  # Id of your main conversation, get it at https://kitcrm.com/oauth/applications
  config.first_conversation_id = 128

  # Id of your secondary conversation, if you haven't one, remove this line
  config.second_conversation_id = 130

  # OAuth key and secret for your application https://kitcrm.com/oauth/applications
  config.key = ENV['kit_key']
  config.secret = ENV['kit_secret']

  # Where to send your user after successfull Kit skill install
  config.after_login_url = 'localhost:3000/account'
end
```

## Usage

### Install Skill for a user

Send your user to the path `/auth/kit` in your application, and after that he'll acquire personal `kit_access_token` that is stored in the database. So, if user has `kit_access_token` - that means he has Skill installed and you can send him conversation.

### Send conversation to a user

By far you should have some conversations created in Kit developer dashboard.

#### Placeholders

Sometimes conversations can include placeholders. Those placeholders are passed along the request, when the conversation is sent.
If you need to pass some placeholder values, override a methods called `kit_first_placeholders` and `kit_second_placeholders` to include hash mapping placeholder name to its value like this:

```ruby
class User < ApplicationRecord
  def kit_first_placeholders
    {
      shop_owner_first_name: self.first_name
    }
  end
end
```

#### Send one
Call a method `user.send_first_step_kit_conversation` or `user.send_second_step_kit_conversation`

#### Send bulk
You can run `bin/rake kit` - that task will send your conversation to every user that has kit Skill account installed.

If you want a precise control of the list of eligible users, override `kit_eligible?` instance method on User class like this, for example

```ruby
class User < ApplicationRecord
  def kit_eligible?
    self.kit_connected? && self.has_been_notified_by_kit_in_20_days?
  end

  def has_been_notified_by_kit_in_20_days?
    # your code here
  end
end
```

### Receive conversation response

After user replied to your Kit dialog, the gem will call one of next callback methods on your user model depending on context:

1. `handle_first_positive_kit_response` - After user said 'yes' to your main conversation
2. `handle_second_positive_kit_response` - After user said 'yes' to your secondary conversation
3. `handle_negative_kit_response` - After user said 'no'
4. `after_send_kit_conversation` - After conversation has been sent to user


This is example of a working customization. Override those methods in your User model like this:

```ruby
class User < ApplicationRecord
  def handle_first_positive_kit_response
    self.kit_logs.create note: "Received response"
    self.send_second_step_kit_conversation
  end

  def handle_second_positive_kit_response
    self.kit_logs.create note: "Received second response"
    KitMailer.write(user).deliver_now!
  end

  def handle_negative_kit_response
    self.kit_logs.create note: "User declined"
  end

  def after_send_kit_conversation
    kit_logs.create note: "Sent offer"
  end
end
```

If you choose not to override some method of those - method will do nothing.

## TODO

- Add tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pemberton-rank/omniauth-kit-oauth2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omniauth::Kit::Oauth2 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/omniauth-kit-oauth2/blob/master/CODE_OF_CONDUCT.md).

Copyright (c) 2017 Pemberton Rank Ltd
