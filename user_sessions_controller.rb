class UserSessionsController < ApplicationController
  before_filter :must_be_logged_out, :only => [:new, :create]
  before_filter :must_be_logged_in, :only => :destroy
  
  layout 'minimal'
  
  def new
    @user_session = UserSession.new
  end
  
  def create 
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default( '/' )
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_back_or_default new_user_session_url
  end
end
