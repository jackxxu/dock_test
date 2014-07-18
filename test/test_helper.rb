require 'bundler/setup'
require 'minitest/autorun'
Bundler.require(:default, :test)

require 'dock_test'

DockTest.config do |c|
  c.url = case ENV['DOCK_ENV']
          when 'production'
            'http://floating-mesa-6194.herokuapp.com'
          else
            'http://localhost:9871'
          end
  c.skippy = :production
end

