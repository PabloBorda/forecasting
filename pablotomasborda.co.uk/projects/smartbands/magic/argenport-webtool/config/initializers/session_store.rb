# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_argenport-webtool_session',
  :secret      => 'd5b98e5e9c46c4a0cb82e73a1b1c52941f2cd08dea52682704b5709e7c4ab68929e241cc344a3260e8d23d10920aad4aa085d49c58395493648e06d005f630ed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
