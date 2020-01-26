require "test_helper"

class SectionCTest < Minitest::Test
  def test_new_class_works
    eval("""class TestClass
      ::SectionC.build  'STATE' do
        primary do
          region 'US'
          language 'English'
        end
      end
    end""")

    assert_instance_of TestClass, TestClass.new
    
  end
end
