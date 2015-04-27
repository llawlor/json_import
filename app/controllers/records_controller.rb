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
    key = params[:key].try(:strip)
    search = params[:search].try(:strip)
    
    # if no search term is present
    if search.blank? || key.blank?
      @records = current_user.records.paginate(:page => params[:page])
    # else perform full text search
    else
      @records = current_user.records.where("to_tsvector(jsonb_extract_path_text(json, ?)) @@ plainto_tsquery(?)", key, search).paginate(:page => params[:page])
      # save key to cookie
      session[:search_key] = key
    end
  end

  # new record page
  def new
    @record = Record.new
  end

  # create a new record
  def create
    @record = current_user.records.new(record_params)
    
    # if the record was saved successfully
    if @record.save
      @record.update_user_json_keys!
      redirect_to records_path
    # else errors
    else
      # reset json
      @saved_json = params[:record][:json]
      render :new
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
    @record = current_user.records.find(params[:id])
    @record.assign_attributes(record_params)
    
    # if the record was saved successfully
    if @record.save
      @record.update_user_json_keys!
      flash[:notice] = 'Document saved.'
      redirect_to @record
    else
      # reset json
      @saved_json = params[:record][:json]
      render :edit
    end  
  end

  private
  
    # permitted record parameters
    def record_params
      params.require(:record).permit(:json)
    end

end
