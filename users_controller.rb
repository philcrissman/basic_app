class UsersController < ApplicationController
  
  skip_before_filter :must_be_logged_in, :only => [:new, :create]
  
  def index
    @users = User.find(:all, :order => "last_name, first_name")
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
    @user.build_user_role
    render :layout => 'minimal'
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User has been created and sent an email with login instructions"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Unable to save user"
      render :action => :new, :layout => 'minimal'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    unless can? :update, @user
      flash[:notice] = "You can't edit this user"
      session[:return_to] = users_path
      unauthorized!
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    unless can? :update, @user
      flash[:notice] = "You can't update this user"
      session[:return_to] = users_path
      unauthorized!
    end
    
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
    
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end
  
  protected
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry; we've had trouble locating your account. Try copying and pasting the URL from your email, or request a new password link."
      redirect_to home_path
    end
  end
end
