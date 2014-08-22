require 'multi_json'
require 'nokogiri'
require 'json-schema'
require 'dock_test/version'
require 'dock_test/methods'
require 'dock_test/dsl'

if defined?(::Minitest)
  require 'dock_test/assertions'
else
end

module DockTest
  extend DSL
end
