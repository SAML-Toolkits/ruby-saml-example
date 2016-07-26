class Account < ActiveRecord::Base
  def self.get_saml_settings(url_base)
    # These are just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    # -------------------------------------------------------------
    # Example settings data, replace these values!
    # -------------------------------------------------------------

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    # SP section
    settings.issuer                         = url_base + "/saml"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

    idp_url_base = 'providerurl'

    # IdP section
    settings.idp_entity_id      = "#{idp_url_base}/saml/metadata"
    # Single-sign on target to POST to
    settings.idp_sso_target_url = "#{idp_url_base}/saml2/idp/login"
    # Single-logout target
    settings.idp_slo_target_url = "#{idp_url_base}/saml2/idp/login"

    # Choose either a cert or a fingerprint to validate the IdP response:
    settings.idp_cert                       = "-----BEGIN CERTIFICATE-----
MIICbjCCAdegAwIBAgIBADANBgkqhkiG9w0BAQ0FADBUMQswCQYDVQQGEwJ1czET
MBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRkwFwYD
VQQDDBBhcHAub25lbG9naW4uY29tMB4XDTE0MDkxMTE1MDUxMVoXDTE1MDkxMTE1
MDUxMVowVDELMAkGA1UEBhMCdXMxEzARBgNVBAgMCkNhbGlmb3JuaWExFTATBgNV
BAoMDE9uZWxvZ2luIEluYzEZMBcGA1UEAwwQYXBwLm9uZWxvZ2luLmNvbTCBnzAN
BgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAsezUGLSiNMXg80EZMMzvXH43f07a1plU
mm1poYvVfgSICTqhEUuA0x4w9w/K4BegO07GVkUjNCrvtJEqq4FMDbHj2VfOCMHx
lYi52/ELXKe6ALSm48y5BG9fd1kGHBqBg741KpMvDkmAbX1sLq5reAjOccIDme2d
lLD8tQ8y0IMCAwEAAaNQME4wHQYDVR0OBBYEFP3cLGEyby7TBXweK0SeFrvnRoHL
MB8GA1UdIwQYMBaAFP3cLGEyby7TBXweK0SeFrvnRoHLMAwGA1UdEwQFMAMBAf8w
DQYJKoZIhvcNAQENBQADgYEAS3vJKRFGjvxOHHNJR77wYlxSSbyb9vmWOVBzaTMd
5TFfoSDxuP9RskRjSrez/63WON6tdYr/mJNSNB70ZAic824Y9feQ/kBaCswI+Pgp
b6sFIh4CrY4yCEkBPD8jXFCeJMq+2AqshbITpiu7WF1RCAp/sRAO56giP/B4l0o0
Tc0=
-----END CERTIFICATE-----"
    #
    # or settings.idp_cert_fingerprint           = "9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D"
    # settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA1

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