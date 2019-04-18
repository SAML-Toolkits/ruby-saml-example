Supported Version
-----------------

This ruby-saml-example project works with rails4 and uses is compatible with the ruby-saml toolkit >= 1.0.0.

Getting Started
---------------

1. Download the ruby-saml-example code
2. Install the required gems `bundle _1.17.3_ update`
3. Execute the command rails server      [It'ss supposed that you installed previously Rails4]
4. Go to http://localhost:3000/ and get "Welcome aboard: You're riding the Rails!"
5. Follow the guidelines to start developing your application


Steps to to in onelogin.com
---------------------------

1. Open [a Developer account](https://developers.onelogin.com)
2. Create new app based on 'SAML Test Connector (IdP)'
3. Filling Configuration tab:
   Audience: `http://localhost:3000/saml/metadata`
   Recipient: `http://localhost:3000/saml/acs`
   ACS (Consumer) URL Validator*: `http://localhost:3000/*`
   ACS (Consumer) URL*: `http://localhost:3000/saml/acs`
4. View X.509 Certificat, SSO Issuer URL, SAML 2.0 Endpoint (HTTP) and SLO Endpoint (HTTP) in SSO tab and fill at `app/models/account.rb`
