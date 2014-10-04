class HostsController < ApplicationController
  def index
    @hosts = Log.all_hosts
  end

  def show
    @hostname = params[:hostname]
    @logs = Log.by_host(@hostname)
  end
end
