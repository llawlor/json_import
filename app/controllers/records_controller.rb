class RecordsController < ApplicationController

  def index
    @records = current_user.records
  end

  def new
    @record = Record.new
  end

  def create
    record = current_user.records.new(record_params)
    
    if record.save
      redirect_to records_path
    end
  end

  def show
    @record = current_user.records.find(params[:id])
  end

  def edit
    @record = current_user.records.find(params[:id])
  end

  def update
    record = current_user.records.find(params[:id])
    record.assign_attributes(record_params)
    
    if record.save
      redirect_to records_path
    end  
  end

  private
  
    def record_params
      params.require(:record).permit(:json)
    end

end
