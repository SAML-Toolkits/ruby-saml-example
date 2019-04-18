class Account < ActiveRecord::Base
  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= "http://localhost:3000"

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    #SP section
    settings.issuer                         = url_base + "/saml/metadata"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

    onelogin_app_id = "922473"

    # IdP section
    settings.idp_entity_id                  = "https://app.onelogin.com/saml/metadata/1289cc09-555c-4719-957f-4a8361bce81f"
    settings.idp_sso_target_url             = "https://cloud-mes-dev.onelogin.com/trust/saml2/http-post/sso/#{onelogin_app_id}"
    settings.idp_slo_target_url             = "https://cloud-mes-dev.onelogin.com/trust/saml2/http-redirect/slo/#{onelogin_app_id}"
    settings.idp_cert                       = "-----BEGIN CERTIFICATE-----
MIID4jCCAsqgAwIBAgIUEUEAWYBOeFD8pHScF6rimU0jxnwwDQYJKoZIhvcNAQEF
BQAwRzESMBAGA1UECgwJQ2xvdWQgTUVTMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAx
GjAYBgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMB4XDTE5MDQxNzA4MjkyN1oXDTI0
MDQxNzA4MjkyN1owRzESMBAGA1UECgwJQ2xvdWQgTUVTMRUwEwYDVQQLDAxPbmVM
b2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA13nnOC+GScd2Jnl/8baja80oM3SZ3/0PUuSb
zOHwaEo10cBn1rzyklnph8GWao3fD750G43QeoRQtshEbsAz+AwBAcwnUbgJ4NyF
mrDmEoOE5bHT8JVP5H7+Kpjz3fariDYgYKGnXobsboU/1I5f7SXkgiy7tohcXCpe
cVR4aXNdhn2c9IABxBAnCA4ysVV/zsP7pGZenuc104kH9RDsknxE25tRCwbBLcdz
Fyp4eEI471Rlz/31fvn101H6KHe3kr2qniyqQUp5MGyhLq18PlkeOqdSjLF3J0Dh
+1tz5jvz+IK6rkRr8nOQpU8LoWXRTVXpSLBNORld4YU5RABrVwIDAQABo4HFMIHC
MAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFIMnMf9K9y7WTiPNPAkK/Du7ccVgMIGC
BgNVHSMEezB5gBSDJzH/Svcu1k4jzTwJCvw7u3HFYKFLpEkwRzESMBAGA1UECgwJ
Q2xvdWQgTUVTMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxv
Z2luIEFjY291bnQgghQRQQBZgE54UPykdJwXquKZTSPGfDAOBgNVHQ8BAf8EBAMC
B4AwDQYJKoZIhvcNAQEFBQADggEBACbfi+lcVHHih9jShzJJty65IhISwTKZ5+kL
V2Dddc1S8aILpTPqr1JDkhVYnqYiQPRH4hXyT5uXiSEOuqUy6eaUrnLixrjLYhgq
WzGZWRep5CzIUWHsodWjK9k+hdd8kZTd2nft2C9PLkfIKt33UKFIyqxeF4BSb2Qa
35p4T0zkJ2RyVAV60R4Y5rxr7uuCqPW2TDPiKdrAog3sM/919nldoYUY2IQAd2hz
QAsID63u/cOGZcQWvGF7OUPT4F1MfQNIm22v3bzSUzsMrtod/zqLOhjfKZ6WTYms
YrGYjmkaOvKW6AC0tMJAQCXpOpBmm099asXpx7E6rjiG5aJuUxE=
-----END CERTIFICATE-----
"


    # or settings.idp_cert_fingerprint           = ""
    #    settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA1

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Security section
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end
end
