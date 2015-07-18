require 'test_helper'

class ErrorMailerTest < ActionMailer::TestCase
  test "send_error" do
    mail = ErrorMailer.send_error
    assert_equal "Send error", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
