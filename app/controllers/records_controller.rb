class RecordsController < ApplicationController

  # import view
  def import; ; end

  # upload documents
  def upload
    # read and parse the file
    file = params[:records].read
    json_records = JSON.parse(file)
    
    # for each json record
    json_records.each do |json_record|
      new_record = current_user.records.create(json: json_record)
      new_record.update_user_json_keys!
    end
  
    flash[:notice] = 'Upload complete'
    redirect_to :back
  end
  
  # view all documents or search results
  def index
    key = params[:key].strip
    search = params[:search].strip
    
    # if no search term is present
    if search.blank? || key.blank?
      @records = current_user.records.paginate(:page => params[:page])
    # else perform full text search
    else
      @records = current_user.records.where("to_tsvector(jsonb_extract_path_text(json, ?)) @@ to_tsquery(?)", key, search).paginate(:page => params[:page])
    end
  end

  # new record page
  def new
    @record = Record.new
  end

  # create a new record
  def create
    record = current_user.records.new(record_params)
    
    # if the record was saved successfully
    if record.save
      record.update_user_json_keys!
      redirect_to records_path
    end
  end

  # show page
  def show
    @record = current_user.records.find(params[:id])
  end

  # edit page
  def edit
    @record = current_user.records.find(params[:id])
  end

  # record is updated
  def update
    record = current_user.records.find(params[:id])
    record.assign_attributes(record_params)
    
    # if the record was saved successfully
    if record.save
      record.update_user_json_keys!
      redirect_to records_path
    end  
  end

  private
  
    # permitted record parameters
    def record_params
      params.require(:record).permit(:json)
    end

end
