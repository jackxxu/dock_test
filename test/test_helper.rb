require 'dock_test'

require 'bundler/setup'
Bundler.require(:default, :test)
require 'minitest/autorun'

DockTest.config do |c|
  c.url = case ENV['DOCK_ENV']
          when 'production'
            'http://floating-mesa-6194.herokuapp.com'
          else
            'http://localhost:9871'
          end
  c.skippy = :production
end

