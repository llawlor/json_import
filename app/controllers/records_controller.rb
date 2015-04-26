class RecordsController < ApplicationController

  def index
    search = params[:search]
    
    # if no search term is present
    if search.blank?
      @records = current_user.records
    # else perform full text search by separating key/value by a space
    else
      json_key = search.split(' ')[0]
      json_value = "#{search.split(' ')[1]}:*"
      @records = current_user.records.where("to_tsvector(jsonb_extract_path_text(json, ?)) @@ to_tsquery(?)", json_key, json_value).all
    end
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
