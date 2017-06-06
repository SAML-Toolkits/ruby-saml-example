class Account < ActiveRecord::Base

  def self.read_file(filename)
    File.read("#{Rails.root}/config/#{filename}")
  end

  def self.get_saml_settings(url_base)
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= "http://#{Rails.configuration.idp[:url_base]}:#{ENV['PORT']}"

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = false

    #SP section
    settings.issuer                         = url_base + "/saml/metadata"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

    # IdP section
    idp_url = "#{Rails.configuration.idp[:idp]}:#{Rails.configuration.idp[:idp_port]}"
    app_login_id = Rails.configuration.idp[:app_login_id]
    settings.idp_entity_id                  = "http://#{idp_url}/saml/metadata/#{app_login_id}"
    settings.idp_sso_target_url             = "http://#{idp_url}/trust/saml2/http-post/sso/#{app_login_id}"
    settings.idp_slo_target_url             = "http://#{idp_url}/trust/saml2/http-redirect/slo/#{app_login_id}"
    settings.idp_cert                       = read_file(Rails.configuration.idp[:idp_cert])
    # or settings.idp_cert_fingerprint           = "3B:05:BE:0A:EC:84:CC:D4:75:97:B3:A2:22:AC:56:21:44:EF:59:E6"
    #    settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA1

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Security section
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings.certificate = read_file(Rails.configuration.idp[:certificate])
    settings.private_key = read_file(Rails.configuration.idp[:private_key])

    settings
  end
end
