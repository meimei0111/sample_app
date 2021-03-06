class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me].eql? Settings.collections.session_controller_create ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t ".sessions.create.warn_mess_session"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "sessions.create.fail_mess_session"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
