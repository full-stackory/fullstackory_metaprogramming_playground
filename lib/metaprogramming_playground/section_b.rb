class SectionB
  # So now that we have seen what metaprogramming tools exists, let's build a
  # more complicated example.
  #
  # Let's say we have some class level attributes that we want to set for a gem.
  # These methods have both getters and setters. 
  ARRAY = [
    :api_key,
    :email,
    :endpoint
  ].freeze

  # The first thing we need to do is open the class up for us to insert class
  # methods.
  class << self
    # Then we want to iterate over the ARRAY and set up our getter and setters
    # methods.
    ARRAY.each do |method|
      # First we define our getter method which gets our class instance variable
      # and returns it.
      define_method(method) do
        instance_variable_get("@#{method}_attr".to_sym)
      end

      # Then we define our setter methods so we can set the value for these class
      # instance variables.
      define_method("#{method}=") do |value|
        instance_variable_set("@#{method}_attr".to_sym, value)
      end
    end
  end
end
