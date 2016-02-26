# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_delivery-magic-wap_session',
  :secret      => '7f64b62bdfe2477218979aa87ddde5b53e97fb971c90f082c02d5eb675b37f98af024f21418187c0eafef5a9d50ad3a0ff09a6aebb99f677aba9997b1542f37c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
