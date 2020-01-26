require "test_helper"

class SectionATest < Minitest::Test

  def test_hello_method_returns_world
    assert_equal SectionA.new.hello(), "world"
  end

  def test_goodbye_returns_interpolated_string
    assert_equal SectionA.new.goodbye("Tim"), "goodbye Tim!"
  end

  def test_class_method_returns_world_string
    assert_equal SectionA.class_hello, "world"
  end

  def test_set_name_correctly_sets_instance
    section = SectionA.new
    section.set_name("Tim")

    assert_equal section.get_name, "Tim"
  end

  def test_send_test_gets_instance_var
    section = SectionA.new
    section.set_name("Banner")

    assert_equal section.testing_send, "Banner"
  end
end
