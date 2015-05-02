  
class HomeController < ApplicationController

  def index
    # if user is signed in, show documents page
    redirect_to records_path and return if current_user.present?
  end

end
