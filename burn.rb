
require 'sonos'

class Burn
  SPEAKER_NAME_REGEX = /Clear Fun/i

  def burn!(burn_url=burn_sound)
    play_sound my_speaker, burn_url
  end

  def burn_sound
    ['https://www.dropbox.com/s/ql3z6d7kmoyof99/sick_burn.mp3?dl=1'].sample
  end

  def play_sound(speaker, audio_url)
    puts "Burning sound #{audio_url}:"
    speaker.voiceover!(audio_url, 50)
  end

  def self.burn!(burn_url=nil)
    new.burn!(burn_url)
  end

  private

  def system
    Sonos::System.new
  end

  def my_speaker
    spkr = system.speakers.select { |spkr| spkr.name =~ SPEAKER_NAME_REGEX }.first
    abort("could not find speaker #{SPEAKER_NAME_REGEX.to_s}!") if spkr.nil?
    spkr
  end
end
