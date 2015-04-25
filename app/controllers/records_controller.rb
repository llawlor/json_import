class RecordsController < ApplicationController

  def index
    @records = current_user.records
  end

end
