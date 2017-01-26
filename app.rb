require 'rubygems'
require 'socket.io-client-simple'

require_relative './burn'

SERVICE_URL = 'http://clearbot.herokuapp.com'

socket = SocketIO::Client::Simple.connect SERVICE_URL

def log(msg)
  puts "** #{msg}"
end

socket.on :connect do
  log "Connected to server: #{SERVICE_URL}"
end

socket.on :disconnect do
  log "Lost contact with server: #{SERVICE_URL}"
  log "I don't know how to reconnect yet.  Please help!"
end

def play_url(url)
  base_burn = ['https://www.dropbox.com/s/ql3z6d7kmoyof99/sick_burn.mp3?dl=1'].sample
  Burn.burn!(url)
end

socket.on :play_url do |data|
  url = data["url"]

  if url.nil?
    log "Unusable payload: #{data}"
  else
    play_url url
  end
end

socket.on :error do |err|
  p err
end

puts "I'm gonna sit and wait for keyboard input forever now... feel free to ignore me."

loop do
  begin
    msg = STDIN.gets.strip
    next if msg.empty?
    socket.emit :chat, {:msg => msg, :at => Time.now}
  rescue Interrupt
    socket.disconnect
    abort "Goodbye!"
  end
end
