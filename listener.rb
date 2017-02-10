require 'rubygems'
require 'socket.io-client-simple'

require_relative './burn'
require_relative './listener'

class SocketDroppedError< StandardError; end

class Listener
  attr_reader :socket
  def initialize
    @socket = SocketIO::Client::Simple.connect(SERVICE_URL,
      ping_interval: 5000, ping_timeout: 1000)
    instrument_socket
    socket
  end

  def dead?
    open = socket.open?
    emitted = socket.emit('health_check', 'hi')
    false
  end
  
  SERVICE_URL = 'http://clearbot.herokuapp.com'
  def instrument_socket
    socket.on :connect do
      puts "Connected to server: #{SERVICE_URL}"
    end

    socket.on :disconnect do
      puts "Lost contact with server: #{SERVICE_URL}"
      puts "I don't know how to reconnect yet.  Please help!"
      raise SocketDroppedError
    end

    socket.on :play_url do |data|
      url = data["url"]

      if url.nil?
        puts "Unusable payload: #{data}"
      else
        Listener.play_url(url)
      end
    end

    socket.on :error do |err|
      p err
    end
  end

  def disconnect
    socket.disconnect
  end

  def self.play_url(url)
    base_burn = ['https://www.dropbox.com/s/ql3z6d7kmoyof99/sick_burn.mp3?dl=1'].sample
    Burn.burn!(url)
  end
end
