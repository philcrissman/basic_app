class PasswordResetsController < ApplicationController
  
  skip_before_filter :must_be_logged_in
  before_filter :must_be_logged_out
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  layout 'minimal'
  
  def new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_email!
      flash[:notice] = "A password reset link has been emailed to you. Please check your email."
      redirect_to home_path
    else
      flash[:notice] = "No user found with this email address"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save!
      flash[:notice] = "Password set successfully!"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Error setting password"
      render :action => :edit
    end
  end
  
end
