class ScriptsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_script, only: [:edit, :update, :destroy, :archive, :unarchive, :grep]
  skip_before_action :authenticate_user!, only: [:sh, :wrapped_sh]

  # GET /scripts
  def index
    if params[:archived] == 'true'
      @scripts = Script.includes(:created_by, :updated_by).archived.order("updated_at desc").page params[:page]
    else
      @scripts = Script.includes(:created_by, :updated_by).active.order("updated_at desc").page params[:page]
    end
  end

  # GET /scripts/wrapped/guid.sh
  def wrapped_sh
    script = Script.where(guid: params[:guid]).first
    if script
      render plain: script.remote_script(root_url)
    else
      render plain: "echo 'script not found'", status: 404
    end
  end

  # GET /scripts/guid.sh
  def sh
    script = Script.where(guid: params[:guid]).first
    if script
      render plain: script.runnable_script(root_url)
    else
      render plain: "echo 'script not found'", status: 404
    end
  end

  # GET /scripts/1
  def show
    @script = Script.find(params[:id])
    @keyword = params[:keyword] || ''
    @highlights = @script.grep_logs(@keyword)
    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  def csv
    script = Script.find(params[:id])
    send_data script.logs_as_csv, type: 'text/csv; charset=UTF-8', filename: 'logs.csv'
  end

  # GET /scripts/new
  def new
    @script = Script.new
  end

  # GET /scripts/1/edit
  def edit
  end

  # POST /scripts
  def create
    @script = Script.new(script_params.merge(created_by: current_user, updated_by: current_user))
    add_attachments

    respond_to do |format|
      if @script.save
        format.html { redirect_to @script, notice: 'Script was successfully created.' }
      else
        flash.now[:alert] = @script.errors.full_messages.to_sentence if @script.errors.any?
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /scripts/1
  def update
    add_attachments
    Attachment.delete params[:delete_attachments] if params[:delete_attachments]

    respond_to do |format|
      if @script.update(script_params.merge(updated_by: current_user))
        format.html { redirect_to @script, notice: 'Script was successfully updated.' }
      else
        flash.now[:alert] = @script.errors.full_messages.to_sentence if @script.errors.any?
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /scripts/1
  def destroy
    @script.destroy
    respond_to do |format|
      format.html { redirect_to scripts_url }
    end
  end

  def archive
    @script.archived = true
    @script.save
    redirect_to script_path(params[:id]), notice: "Script was successfully archived."
  end

  def unarchive
    @script.archived = false
    @script.save
    redirect_to script_path(params[:id]), notice: "Script was successfully unarchived."
  end

  def grep
    render json: @script.grep_logs(params[:keyword])
  end

  def search
    @keyword = params[:keyword]
    if params[:archived] == 'true'
      @scripts = Script.includes(:created_by, :updated_by)
                       .archived
                       .search(@keyword)
                       .order("updated_at desc")
                       .page(params[:page])
                       .per(5)
    else
      @scripts = Script.includes(:created_by, :updated_by)
                       .active
                       .search(@keyword)
                       .order("updated_at desc")
                       .page(params[:page])
                       .per(5)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_script
      @script = Script.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def script_params
      params.require(:script).permit(:name, :body, :archived)
    end

    def attachment_params
      params.permit(attachments: [:upload])
    end

    def add_attachments
      (attachment_params[:attachments] || []).each do |attachment|
        @script.attachments << Attachment.new(attachment)
      end
    end

end
