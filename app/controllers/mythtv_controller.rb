require 'socket'
class MythtvController < ApplicationController
  def test
    connection = TCPSocket::new("192.168.1.10", 6543)
    connection.write(buildMessage("MYTH_PROTO_VERSION 50")
    str = connection.recv(22)
    connection.write(buildMessage("ANN Playback sycamore 0")
    str = str + "\n" + connection.recv(11)
    connection.write(buildMessage("QUERY_RECORDINGS Delete")
    retMsg = connection.recv(8)
    str = str + retMsg
    n = Integer(retMsg)
    i = 0
    reply = ""
    while i < n:
      reply += connection.recv(n - i)
      i = reply.length
    end

    str += reply
    connection.close
    render :text => str
  end

  def buildMessage(command)
    return "%-8d%s" % [message.length, message]
  end
end
