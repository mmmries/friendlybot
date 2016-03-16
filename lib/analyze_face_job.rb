require "securerandom"
require_relative "analyzer"

class AnalyzeFaceJob
  include SuckerPunch::Job

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
        $client.update_with_media("This guy is #{analyzer.expression}", fh)
      end
    end
    File.unlink(filepath)
  end
end
