require "constructor"
require "minitest/autorun"
require "mutant"
require "mutant/minitest/coverage"

class ConstructorTest < Minitest::Test
  cover Constructor

  def test_allows_default_initializer
    klass =
      Class.new do
        extend Constructor
        def initialize
          @state = :draft
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new
    assert_equal instance.state, :draft
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_arguments
    klass =
      Class.new do
        extend Constructor
        def initialize(a, b)
          @state = a + b
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(2, 3)
    assert_equal instance.state, 5
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_keyword_arguments
    klass =
      Class.new do
        extend Constructor
        def initialize(a:, b:)
          @state = a + b
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(a: 2, b: 3)
    assert_equal instance.state, 5
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_variable_arguments
    klass =
      Class.new do
        extend Constructor
        def initialize(*args)
          @state = args.reduce(:+)
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(1, 2, 3)
    assert_equal instance.state, 6
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_variable_keyword_arguments
    klass =
      Class.new do
        extend Constructor
        def initialize(**args)
          @state = args.values.reduce(:+)
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(a: 1, b: 2, c: 3)
    assert_equal instance.state, 6
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_mixed_arguments
    klass =
      Class.new do
        extend Constructor
        def initialize(a, *args, b:, **kwargs)
          @state = a + b + args.reduce(:+) + kwargs.values.reduce(:+)
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(1, 2, 3, b: 4, c: 5, d: 6)
    assert_equal instance.state, 21
    assert_equal instance.version, -1
  end

  def test_allows_initializer_with_block
    klass =
      Class.new do
        extend Constructor
        def initialize(a, *args, b:, **kwargs, &block)
          @state = block.call(a + b + args.reduce(:+) + kwargs.values.reduce(:+))
        end
        attr_reader :state
        attr_reader :version
      end

    instance = klass.new(1, 2, 3, b: 4, c: 5, d: 6) { |val| val * 2 }
    assert_equal instance.state, 42
    assert_equal instance.version, -1
  end
end
