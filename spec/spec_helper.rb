require 'elasticsearch'
require 'es_helper'

require 'elasticsearch/index_stager'

RSpec.configure do |config|
  #config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before(:suite) do
    ESHelper.setup
    ESHelper.startup
  end

  config.after(:suite) do
    ESHelper.shutdown
  end
end
