require 'test/unit'
require 'test/unit/ui/console/testrunner'
require_relative "../services/EmailSender.rb"


class EmailSenderTest < Test::Unit::TestCase
  
  include Services
  
  @email_service
  
  
  def setup
    @email_service = EmailSender.get_instance
  end
  
  
  def teardown
  end
  
  def test_send_email
    @email_service.send_email("pablotomasborda@gmail.com","process_notification@localhost","This is a test email, check junk folder")
    
  end
  
end

Test::Unit::UI::Console::TestRunner.run(EmailSenderTest)