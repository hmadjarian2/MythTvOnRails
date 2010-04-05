require 'socket'
class MythtvController < ApplicationController
  def initialize
    connect()
  end

  def getRecordings
    executeCommand("QUERY_RECORDINGS Delete")
    recordings = populateRecordings(getCommandResponse())

    recordings.each do |recording|
      puts recording.title
    end
  end

  private

  def connect()
    @connection = TCPSocket::new("192.168.1.10", 6543)
    executeCommand("MYTH_PROTO_VERSION 50")
    getCommandResponse()

    executeCommand("ANN Playback MythTvOnRails 0")
    getCommandResponse()

    isConnected = true
  end

  def disconnect()
    @connection.close
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

  def populateRecordings(serverResponse)
    count = Integer(serverResponse[0])

    recordings = Array.new(count)

    recordingIndex = 0
    fieldIndex = 1
    while recordingIndex < count:
      recording = Recording.new
      recording.title = serverResponse[fieldIndex]
      recording.subtitle = serverResponse[fieldIndex + 1]
      fieldIndex = fieldIndex + 47
      recordingIndex = recordingIndex + 1
      recordings << recording
    end

    return recordings
  end
end
