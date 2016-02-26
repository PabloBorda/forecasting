require "test/unit"
require "xmpp4r/client"
require "app/helpers/application_helper.rb"
include Jabber
include ApplicationHelper

class JabberTalkTest < Test::Unit::TestCase
	

	
	def test_jabber_talk
		jid = JID::new('delivery-magic@localhost/localhost')
        password = 'p2t3t4l5c6'
        cl = Client::new(jid)
        cl.connect
        cl.auth(password)
		to = "store01@localhost/localhost"
        subject = "XMPP4R test"
        body = "You got deliver request!"
        m = Message::new(to, body).set_type(:normal).set_id('1').set_subject(subject)
        cl.send m
	end
	
	def test_jabber_adviser
		ja = JabberAdviser.new('delivery-magic@localhost/localhost','p2t3t4l5c6')
		ja.advise("store01@localhost/localhost","HOLA LOQUITO!")
	end
	
	
end