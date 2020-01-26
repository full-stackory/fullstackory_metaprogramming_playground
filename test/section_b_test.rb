require "test_helper"

class SectionBTest < Minitest::Test
  def test_api_key_returns_value
    SectionB.api_key = 'correct'
    assert_equal SectionB.api_key, 'correct'
  end

  def test_email_returns_value
    assert_nil SectionB.email

    SectionB.email = 'asd@asd.com'

    assert_equal SectionB.email, 'asd@asd.com'
  end
end
