require 'socket'

class MythtvController < ApplicationController
  def initialize
    @mythServer = MythTvServer.new("192.168.1.10")
    @mythServer.connect()
  end

  def getRecordings
    @recordings = @mythServer.getAllRecordings()
  end

  def getScheduledRecordings
    @recordings = @mythServer.getUpcomingRecordings()
  end
end
