class SessionsController < Devise::SessionsController
  respond_to :html
  def destroy
    super
    Netzke::Core.reset_components_in_session
    reset_session
    logger.debug "Session destroyed"
  end
end
