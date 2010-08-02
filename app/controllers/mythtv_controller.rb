require 'socket'
require 'ProgramInfoFields'

class MythtvController < ApplicationController
  def initialize
    connect()
  end

  def getRecordings
    connect()
    executeCommand("QUERY_RECORDINGS Delete")
    @recordings = populateRecordings(getCommandResponse(), 0)
  end

  def getScheduledRecordings
    executeCommand("QUERY_GETALLPENDING")
    @recordings = populateRecordings(getCommandResponse(), 1)
    #@response = getCommandResponse()
  end

  private

  def connect()
    if @isConnected
      return
    end

    @connection = TCPSocket::new("192.168.1.10", 6543)
    executeCommand("MYTH_PROTO_VERSION 50")
    getCommandResponse()

    executeCommand("ANN Playback MythTvOnRails 0")
    getCommandResponse()

    @isConnected = true
  end

  def disconnect()
    if @isConnected
      executeCommand("DONE")
      @connection.close
      @isConnected = false
    end
  end

  def buildCommandString(command)
    return "%-8d%s" % [command.length, command]
  end

  def executeCommand(commandText)
    @connection.write(buildCommandString(commandText))
  end

  def getCommandResponse()
    responseCode = @connection.recv(8)
    if responseCode.upcase == "OK"
      return "OK"
    end

    characterCount = Integer(responseCode)
    responseText = ""
    charactersReceived = 0

    while charactersReceived < characterCount:
      responseText += @connection.recv(characterCount - charactersReceived)
      charactersReceived = responseText.length
    end

    return responseText.split("[]:[]")
  end

  def populateRecordings(serverResponse, recordCountIndex)
    @response = serverResponse
    count = Integer(serverResponse[recordCountIndex])

    recordings = Array.new

    recordingIndex = 0
    fieldIndex = recordCountIndex + 1
    while recordingIndex < count:
      recording = Recording.new
      recording.title = serverResponse[fieldIndex + ProgramInfoFields::TITLE]
      recording.subtitle = serverResponse[fieldIndex + ProgramInfoFields::SUBTITLE]
      recording.description = serverResponse[fieldIndex + ProgramInfoFields::DESCRIPTION]
      recording.category = serverResponse[fieldIndex + ProgramInfoFields::CATEGORY]
      recording.chanid = serverResponse[fieldIndex + ProgramInfoFields::CHANID]
      recording.channum = serverResponse[fieldIndex + ProgramInfoFields::CHANNUM]
      recording.callsign = serverResponse[fieldIndex + ProgramInfoFields::CALLSIGN]
      recording.channame = serverResponse[fieldIndex + ProgramInfoFields::CHANNAME]
      recording.starttime = Time.at(Integer(serverResponse[fieldIndex + ProgramInfoFields::STARTTIME]))
      recording.endtime = Time.at(Integer(serverResponse[fieldIndex + ProgramInfoFields::ENDTIME]))
      recording.playgroup = serverResponse[fieldIndex + 30]
      fieldIndex = fieldIndex + 47
      recordingIndex += 1
      recordings << recording
    end

    return recordings
  end
end
