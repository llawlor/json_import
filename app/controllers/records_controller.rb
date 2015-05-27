class RecordsController < ApplicationController
  before_filter :check_records_limit, only: [:new, :create, :import, :upload]
  
  # export all json documents
  def export
    send_data current_user.records.select(:json).order('updated_at desc').collect(&:json).to_json, filename: 'records.json'
  end
  
  # delete all entries
  def delete
    # delete the records
    current_user.records.find_each { |record| record.destroy }
    # reset user info
    current_user.update_column(:json_keys, [])
    # redirect
    redirect_to records_path
  end
  
  # delete an entry
  def destroy
    @record = current_user.records.find(params[:id])
    if @record.present?
      @record.destroy 
      flash[:alert] = 'Document deleted.'
    end
    redirect_to records_path
  end
  
  # import view
  def import; ; end

  # upload documents
  def upload
    # read and parse the file
    file = params[:records].read
    json_records = JSON.parse(file)
    
    # for each json record
    json_records.each do |json_record|
    
      # check records limit
      if current_user.records_limit_reached?
        flash[:alert] = 'Sorry, you have reached the maximum number of records.'
        redirect_to records_path and return
      end
      
      # add the record
      new_record = current_user.records.new(json: json_record)
      
      # if the created_at date is present
      if json_record['created_at'].present?
        begin
          parsed_time = Time.parse(json_record['created_at'])
          new_record.created_at = parsed_time
          new_record.updated_at = parsed_time
        rescue
        end
      end
      
      # save the record
      new_record.save
      # update user keys
      new_record.update_user_json_keys!
    end
  
    flash[:notice] = 'Upload complete'
    redirect_to records_path
  end
  
  # view all documents or search results
  def index
    key = params[:key].try(:strip)
    search = params[:search].try(:strip)
    
    # if no search term is present
    if search.blank? || key.blank?
      @records = current_user.records.order("updated_at desc").paginate(:page => params[:page])
    # else perform full text search
    else
      @records = current_user.records.where("to_tsvector(jsonb_extract_path_text(json, ?)) @@ plainto_tsquery(?)", key, search).order("updated_at desc").paginate(:page => params[:page])
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
    
    # delete any blank rows
    @record.json.delete("")
    
    # if the record was saved successfully
    if @record.save
    
      # push to redis
      conn = Hiredis::Connection.new
      conn.connect("127.0.0.1", 6379)
      conn.write ["PUBLISH", "record", @record.to_json]
      conn.read
      
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

    # check if we're at the maximum records
    def check_records_limit
      if current_user.records_limit_reached?
        flash[:alert] = 'Sorry, you have reached the maximum number of records.'
        redirect_to records_path and return
      end
    end
end
