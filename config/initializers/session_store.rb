# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_MythTvOnRails_session',
  :secret      => 'cde046dd12eb78c82a0834fbdbdabe38b7e29ad8eb8b02c998576ab1a227a0806c9001ecb9eb9849b07fe4e5b49863944d834799023e0d0773d0f3cd4126ac3c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
