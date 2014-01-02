require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
end

at_exit { ChefSpec::Coverage.report! }
