# DockTest Gem
<img src="https://raw.githubusercontent.com/jackxxu/dock_test/master/dock_test_logo.jpeg" alt="DockTest Gem" align="right" height="300" width="320"/>

### Description

DockTest is an outside-in testing framework for ruby service api applications.

### Features

Different from the popular [Rack::Test], DockTest focuses on just on service applications and tests 100% from outside.

1. 100% end-to-end as it is based on HTTP requests/responses. When testing in local mode, it also racks up the local rack server.
2. same tests can run for all deployment environments - development, test, staging, and production.
3. environment-specific `skippy` setting to automatically skip tests with requests that create side-effects in production environments.
4. focuses on service applications to strip out sessions, cookies, javascript, file uploads, and other browser-related features.
5. provides custom assertions that are specific to api responses, including schema validation.
6. same methods as [Rack::Test] for easy test reuse.

### Sample Application

1. Rack Application based on [newark]: [https://github.com/jackxxu/sample_dock_tested_app](https://github.com/jackxxu/sample_dock_tested_app)
2. Rack Application based on [grape]:
3. Rack Application based on [rails-api]:

### Install

Add this line to your application's Gemfile:

```ruby
  group :test do
    gem 'dock_test'
  end
```

And then execute:

    $ bundle

In your test helper file (often `test/test_helper.rb`), include the following DockTest configuration:

```ruby
DockTest.configure do |c|
  c.url = case ENV['DOCK_ENV']
          when 'production'
            'http://vast-reaches-9635.herokuapp.com/' # your production service url
          when ...
          else
            'http://localhost:9871' # your local service url with abitary unbound port number
          end
  c.skippy = :production # in production mode, skip all the post, delete, put requests.
end
```

Add `include DockTest::Methods` to give your integration tests access to all the verb test methods and also assertions.

Now you can excute your test collectively or individually, such as:

    $ bundle exec rake test
    $ DOCK_ENV=product bundle exec rake test

### Assumptions

1. when testing local application, a `config.ru` exists that can be used to `rackup` the server.


[Rack::Test]: https://github.com/brynary/rack-test
[newark]: https://github.com/mje113/newark
[grape]: https://github.com/intridea/grape
[rails-api]: https://github.com/rails-api/rails-api
