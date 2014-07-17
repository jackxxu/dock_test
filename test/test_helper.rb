require 'dock_test'

require 'bundler/setup'
Bundler.require(:default, :test)
require 'minitest/autorun'

DockTest.url = (ENV['DOCK_ENV'] == 'production') ? 'http://floating-mesa-6194.herokuapp.com' : 'http://localhost:9871'
