require 'bundler/setup'
require 'minitest/autorun'
Bundler.require(:default, :test)

require 'dock_test'

DockTest.configure do |c|
  case ENV['DOCK_ENV']
  when 'production'
    c.url = 'http://floating-mesa-6194.herokuapp.com'
    c.skippy = true
  else
    c.url = 'http://localhost:9871'
    c.skippy = false
  end
end

