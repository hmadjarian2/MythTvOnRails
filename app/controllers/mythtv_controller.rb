require 'socket'
class MythtvController < ApplicationController
  def test
    server = TCPSocket::new("192.168.1.10", 6543)
    server.write("21      MYTH_PROTO_VERSION 50")
    str = server.recv(22)
    server.write("23      ANN Playback sycamore 0")
    str = str + "\n" + server.recv(11)
    server.write("23      QUERY_RECORDINGS Delete")
    str = str + server.recv(8)
    server.close
    render :text => str
  end
end
