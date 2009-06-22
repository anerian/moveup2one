# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_moveup2one_session',
  :secret      => '6f3cfc1c8c2787c6c6035707f780f98ce4e182033e6cb098d41387787ea41034bd135f5ddc7423241f62ff96eb7046f4f4c74b68fddd5372f8c6e97253c751cf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
