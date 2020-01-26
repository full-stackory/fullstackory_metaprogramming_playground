class SectionC
  # So far so good right! Now let's talk about a DSL, Domain Specific Language.
  # DSLs are everywhere in Ruby and Rails. They add such magic to the developer
  # experience. Chances are, you have used DSLs. Ever used `belongs_to` or
  # `has_many`?
  #
  # Let's build our own DSL. Let's define what its API will look like.
  # Let this definition below be our DSL.
  # ```ruby
  # class SomeOtherClass
  #   build do
  #     primary do
  #       region 'USA'
  #       language 'English'
  #     end
  #   end
  # end
  # ```

  # To start, we create a class method that takes a block. 
  def self.build(state, &block)
    SectionC.new(state, &block)
  end

  # When we initialize this class, we want to ensure we have state within the
  # instance and pass it a block to execute via `instance_eval`.
  def initialize(state, &block)
    @state = state

    instance_eval(&block)
  end

  # As we have a `primary` block in our DSL, we have to define this. This gets
  # executed in our `instance_eval` above in our `initialize` method.
  def primary(&block)
    SectionC::PrimaryScope.new(@state, &block)
  end

  # Here is where things are getting tricky! We generally create a new subclass
  # that stores portions of the state for our primary block. Here, we set an
  # instance variable `@klass` to an the `PrimaryAttributes` class with the
  # state being set as a constant within the class. We then evaluate the block
  # being passed in at the instance level.
  class PrimaryScope
    def initialize(state, &block)
      @klass = PrimaryAttributes.const_set state, Class.new(PrimaryAttributes)

      instance_eval(&block)
    end

    # This is one of the funnest parts of Ruby! If a method is missing within a
    # class, this method gets invoked. Here we want to override Ruby's default
    # behavior and essentially set the missing attribute to the value being
    # pssed in.
    def method_missing(m, *attr, &block)
      AttributeScope.new(@klass, m, attr, &block)
    end
  end

  # We store our various attributes at an instance variable level. This way we
  # can store certain aspects of our DSL within objects.
  class AttributeScope
    def initialize(klass, method, attr, &block)
      klass.send(:instance_variable_set, "@#{method}", attr)
    end
  end

  class PrimaryAttributes
    attr_accessor :region, :language
  end
end
