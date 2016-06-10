require 'active_support'

if ActiveSupport.respond_to?(:test_order)
  ActiveSupport.test_order = :random
end
