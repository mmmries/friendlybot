require "securerandom"
require_relative "analyzer"

class AnalyzeFaceJob
  include SuckerPunch::Job

  PHRASES = {
    :anger => [
      "Chill out. No reason to get mad.",
      "Calm down, the garbage collector will clean up soon",
    ],
    :joy => [
      "Must have just watched a kitten video.",
      "Test suite just went green!",
    ],
    :sorrow => [
      "Cheer up friend",
      "Don't worry, you can stop writing javascript soon",
    ],
    :surprise => [
      "WAT?!?!?",
      "NaN NaN Naj NaN NaN NaN NaN NaN NaN",
    ],
    :unknown => [
      "No idea what is going on with this person",
      "Did you think this was a .NET conference?",
    ]
  }

  def perform(frame, rect)
    puts "I am going to analyaze this face!"
    filepath = File.join(ENV["PICTURES_DIR"], "#{SecureRandom.uuid}.jpg")
    frame.write(filepath)
    analyzer = Analyzer.new(filepath)
    if analyzer.blurry?
      puts "...nevermind, this picture sucks"
      return nil
    else
      File.open(filepath, "rb") do |fh|
        phrase = PHRASES[analyzer.expression].sample
        $client.update_with_media(phrase, fh)
      end
    end
    File.unlink(filepath)
  end
end
