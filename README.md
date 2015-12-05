Welcome to the ruby-saml project example for Rails4 
===================================================

Supported Version
-----------------

This ruby-saml-example project works with rails4 and uses is compatible with the ruby-saml toolkit >= 1.0.0.

Getting Started
---------------

### Download the ruby-saml-example code

    $ git clone <path-to-repo>

### Add your identity provider credentials

Configure your identity provider settings in `Account`.

### Install the required gems

    $ bundle install

### Initialize the DB

    $ bundle exec rake db:setup

### Start the Rails server

    $ bundle exec rails server

### Visit the home page and log in

Open `http://localhost:3000` in your browser, and click on the "Login"
link to be directed to your IdP SAML login path.
