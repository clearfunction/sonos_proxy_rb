require_relative './listener'

def reload!
  puts "** Setting up a new listener..."
  @listener = Listener.new
end

def main
  reload!

  puts "I'm gonna sit and wait for keyboard input forever now... feel free to ignore me."

  loop do
    begin
      sleep 1
      
      reload! if @listener.dead?
    rescue SocketDroppedError, Errno::ECONNRESET
      reload!
    rescue Interrupt
      @listener.disconnect

      abort "Goodbye!"
    end
  end
end

main
