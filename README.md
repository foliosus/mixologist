# README

To get up and running, assuming you've got the correct Ruby installed (see the `.ruby-version` file), and a valid `database.yml`, should be as simple as `bundle install && rails db:setup`.

To run the test suite, `rails test` is your friend.

The site doesn't have any serious complications; there is no email, no background tier, and no other dependencies like a search service.

## Hosting

The app is hosted by Heroku and served from [drinks.mixologi.st](https://drinks.mixologi.st).

## DNS

The domain is registered with [nic.st](https://nic.st/). [CloudFlare](https://dash.cloudflare.com) lives in front of the app, and provides both the name servers and the DNS service since it does a much better job than nic.st.
