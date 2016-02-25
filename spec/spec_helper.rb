require 'elasticsearch'
require 'elasticsearch/index_stager'

require 'es_helper'

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
