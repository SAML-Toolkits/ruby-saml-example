class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:acs, :logout]

  def index
      render :action => :index
  end

  def sso
    settings = Account.get_saml_settings
    if settings.nil?
      render :action => :no_settings
      return 
    end

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(settings))
    # redirect_to(request.create(saml_settings, {:RelayState => session[:return_to]}))

  end

  def acs
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = Account.get_saml_settings

    logger.info "NAMEID: #{response.name_id}"

    if response.is_valid?
      session[:userid] = response.name_id
      session[:attributes] = response.attributes
      @attrs = session[:attributes]
      render :action => :complete
    else
      render :action => :fail
    end
  end

  def metadata
    settings = Account.get_saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render :xml => meta.generate(settings)
  end

  # Trigger SP and IdP initiated Logout requests
  def logout
    # If we're given a logout request, handle it in the IdP initiated method
    if params[:SAMLRequest]
      return idp_logout_request
    
    # We've been given a response back from the IdP 
    elsif params[:SAMLResponse]
      return logout_response
    elsif params[:slo]
      return sp_logout_request
    else
      delete_session
    end
  end

  # Create an SP initiated SLO
  def sp_logout_request
    # LogoutRequest accepts plain browser requests w/o paramters
    settings = Account.get_saml_settings

    if settings.idp_slo_target_url.nil?
      logger.info "SLO IdP Endpoint not found in settings, executing then a normal logout'"
      delete_session
    else

      # Since we created a new SAML request, save the transaction_id
      # to compare it with the response we get back
      logout_request = OneLogin::RubySaml::Logoutrequest.new()
      session[:transaction_id] = logout_request.uuid
      logger.info "New SP SLO for userid '#{session[:userid]}' transactionid '#{session[:transaction_id]}'"

      if settings.name_identifier_value.nil?
        settings.name_identifier_value = session[:userid]
      end

      relayState =  url_for controller: 'saml', action: 'index'
      redirect_to(logout_request.create(settings, :RelayState => relayState))
    end
  end

  # After sending an SP initiated LogoutRequest to the IdP, we need to accept
  # the LogoutResponse, verify it, then actually delete our session.
  def logout_response
    settings = Account.get_saml_settings
    logout_response = OneLogin::RubySaml::Logoutresponse.new(params[:SAMLResponse], settings)

    logger.info "LogoutResponse is: #{logout_response.to_s}"

    # Validate the SAML Logout Response
    if not logout_response.validate
      logger.error "The SAML Logout Response is invalid"
    
    elsif session[:transation_id] && logout_response.in_response_to != session[:transaction_id]
      logger.error "The SAML Response for #{logout_response.in_response_to} does not match our session transaction ID of #{session[:transaction_id]}"

    elsif logout_response.issuer != settings.idp_metadata
      logger.error "The SAML Response from IdP #{logout_response.issuer} does not match our trust relationship with #{settings.idp_metadata}"
    else
      # Actually log out this session
      if logout_response.success?
        logger.info "Delete session for '#{session[:userid]}'"
        delete_session
      end
    end
  end

 # Method to handle IdP initiated logouts
  def idp_logout_request

    render :inline => "IdP initiated Logout not supported"

    #settings = Account.get_saml_settings
    #logout_request = OneLogin::RubySaml::Logoutrequest.new(params[:SAMLRequest],settings)
    #unless logout_request.is_valid?
    #  logger.error "IdP initiated LogoutRequest was not valid!"
    #end
    # Check that the name ID's match
    #if session[:userid] != logout_request.name_id
    #  logger.error "The session's Name ID '#{session[:userid]}' does not match the LogoutRequest's Name ID '#{logout_request.name_id}'"
    #end
    #logger.info "IdP initiated Logout for #{logout_request.name_id}"

    # Actually log out this session
    #delete_session

    # Generate a response to the IdP.  :transaction_id sets the InResponseTo
    # SAML message to create a reply to the IdP in the LogoutResponse.
    #action, content = logout_response = OneLogin::RubySaml::Logoutresponse.new(nil, settings).
    #  create(:transaction_id => logout_request.transaction_id)

    #case action
    #  when "GET"
    #    # for GET requests, do a redirect on the content
    #    redirect_to content
    #  when "POST"
    #    # for POST requests (form) render the content as HTML
    #    render :inline => content
    #end
  end

  # Delete a user's session.  Add your own custom stuff in here 
  def delete_session
    session[:userid] = nil
    session[:attributes] = nil
  end

end
