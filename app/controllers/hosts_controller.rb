class HostsController < ApplicationController
  def index
    @hosts = Log.all_hosts
  end
end
