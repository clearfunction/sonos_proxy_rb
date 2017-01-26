require 'rubygems'
require 'socket.io-client-simple'

require_relative './burn'

SERVICE_URL = 'http://clearbot.herokuapp.com'

socket = SocketIO::Client::Simple.connect SERVICE_URL

socket.on :connect do
  puts "connected!!!"
end

socket.on :disconnect do
  puts "disconnected!!"
end

def play_url(url)
  base_burn = ['https://www.dropbox.com/s/ql3z6d7kmoyof99/sick_burn.mp3?dl=1'].sample
  Burn.burn!(url)
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
