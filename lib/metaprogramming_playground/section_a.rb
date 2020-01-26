class SectionA
  # This class is an introduction to metapgramming. In this class, we will go
  # over available tools and some patterns that make metaprogramming a joy in
  # ruby.

  # This first tool we will go over is `define_method` (https://ruby-doc.org/core-2.7.0/Module.html#method-i-define_method)
  # `define_method` allows us to define an instance method. `define_method` can
  # take 2 arguments: :symbol that defines the instance method name and a block
  # that defines the behavior of the method.
  # Here below, you can see us using the `define_method` method taking two
  # arguments. We can expect `SectionA.new.hello` to return `"world"`.
  #
  # What happens if we want our method to take an argument?
  define_method(:hello) do
    "world"
  end

  # To dynamically create a method that takes arguments, we simply modify the
  # second argument, the block, for the define_method call. We can pass it any
  # number of arguments to the block and have access to them in the block. As
  # shown below, we can expect an instance method named `goodbye(name)` to return
  # `"goodbye #{name}!"`.
  #
  # Another way to, non dynamically, create this method is simply
  # ```
  # def goodbye(name)
  #   "goodbye #{name}!"
  # end
  define_method(:goodbye) do |name|
    "goodbye #{name}!"
  end

  # This is fantastic! So we know how to do instance methods, what about a class
  # method? Well, there are several ways to do this. The cleanest, in our opinion,
  # is to access the singleton through using `class << self do; end`. Using this
  # opens us to the class methods and variables and allows us to define methods
  # for the class. As such, we expect `SectionA.class_hello` to return `"world"`
  class << self
    def class_hello
      "world"
    end
  end

  # Amazing! So we can dynamically create class methods and instance methods. It
  # is important to note that since we are dynamically creating these methods,
  # all of this happens at runtime of your program.
  #
  # `instance_variable_get` https://ruby-doc.org/core-2.7.0/Object.html#method-i-instance_variable_get
  # `instance_variable_set` https://ruby-doc.org/core-2.7.0/Object.html#method-i-instance_variable_set
  #
  # The next important tool to understand is `instance_variable_get` and
  # `instance_variable_set`. Each of these work with instance variables within
  # an instance of a class. Below we are going to create two methods: `set_name`
  # and `get_name`.
  define_method(:set_name) do |name|
    instance_variable_set(:@name, name)
  end

  define_method(:get_name) do
    instance_variable_get(:@name)
  end

  # Based on the above two methods, I would expect the following to occur:
  # ```
  # a = SectionA.new
  # a.set_name("Billy") # => sets @name to "Billy"
  # a.get_name # => "Billy"
  # ```

  # This is pretty powerful stuff! The possibilities are endless when
  # potentially having to deal with a variety of dynamicism like dynamic
  # instance variables!

  # `send` https://ruby-doc.org/core-2.7.0/Object.html#method-i-send
  # `eval` https://ruby-doc.org/core-2.7.0/Kernel.html#method-i-eval
  # The last two important tools are very powerful and should be used with
  # restraint. There are two ruby methods, `send` and `eval`, that dynamically
  # execute code. `eval` is _very_ dangerous and as such should RARELY be used.
  # Most times, `send` should be sufficient.
  #
  # Below we are going to define a method that invokes send (on implicit self)
  # and attempts to invoke the `:get_name` method. We should expect `testing_send`
  # to return the value stored in `@name`.
  def testing_send
    send(:get_name)
  end

  # If we wanted to do the above as eval, we would have to either create a
  # binding to pass into eval OR instantiate SectionA in the eval.
  def eval_first
    eval("a = SectionA.new() && a.set_name('test') && a.get_name")
  end

  # One parting note on eval. Eval is VERY dangerous. If your system was ever
  # compromised and someone knew of your eval and how to evoke it, it could
  # quickly become an RCE (remote command execution) vector. 
end
