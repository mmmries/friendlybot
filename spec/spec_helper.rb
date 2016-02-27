require 'bundler/setup'
require 'rspec/autorun'

require 'spyglass'

RSpec.configure do |c|
  c.order = :rand
  c.color = true
end
