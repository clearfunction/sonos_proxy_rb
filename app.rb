require 'rubygems'
require 'socket.io-client-simple'

require_relative './burn'

SERVICE_URL = 'http://localhost'

socket = SocketIO::Client::Simple.connect SERVICE_URL

socket.on :connect do
  puts "connected!!!"
end

socket.on :disconnect do
  puts "disconnected!!"
end

def play_url(url)
  puts "Would burn: #{url}"
  #Burn.burn! url
end

socket.on :play_url do |data|
  url = data["url"]

  if url.nil?
    puts "Unusable payload: #{data}"
  else
    play_url url
  end
end

socket.on :error do |err|
  p err
end

puts "Please input and press Enter key"

loop do
  begin
    msg = STDIN.gets.strip
    next if msg.empty?
    socket.emit :chat, {:msg => msg, :at => Time.now}
  rescue Interrupt
    socket.disconnect
    abort "goodbye!"
  end
end
