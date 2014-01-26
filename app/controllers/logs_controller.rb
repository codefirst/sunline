class LogsController < ApplicationController
  include LogsHelper

  before_action :set_log, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # POST /logs
  # POST /logs.json
  def create
    if params[:log_file].nil?
      render json: {message: "log file not specified"}.to_json, status: 500
      return
    end

    @log = Log.new(host: params[:host], :result => params[:log_file].read)
    script = Script.where(guid: params[:guid]).first
    unless script
      render json: {message: "scripts not found. GUID: #{params[:guid]}"}.to_json, status: 500
      return
    end

    script.logs << @log

    respond_to do |format|
      if @log.save
        format.html { render text: "log registration successful\n", status: :created}
        format.json { render action: 'show', status: :created, location: @log }
      else
        format.html { render text: "log registration failure\n", status: 500 }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end

    post_hooks(@log)
  end

  def edit
  end

  def update
    @log.memo = params[:log][:memo]
    @log.save
    redirect_to log_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_log
    @log = Log.find(params[:id])
  end

  def post_hooks(log)
    json = log.hook_json(log_url(log))

    log.script.hooks.each do |hook|
      begin
        Faraday.post hook.url, payload: json
      rescue => e
        logger.error e
      end
    end
  end
end
