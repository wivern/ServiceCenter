class SessionsController < Devise::SessionsController
  respond_to :html
  def destroy
    super
    reset_session
    logger.debug "Session destroyed"
  end
end
