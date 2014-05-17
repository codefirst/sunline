class HostsController < ApplicationController
  def index
    @hosts = Log.all_hosts
  end

  def show
    @logs = Log.by_host(params[:hostname])
  end
end
