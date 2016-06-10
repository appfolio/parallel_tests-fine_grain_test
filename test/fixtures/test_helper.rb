require 'active_support'

# ActiveSupport 4.2 requires we set test_order
ActiveSupport.test_order = :random if ActiveSupport.respond_to?(:test_order)
