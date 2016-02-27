#api_key = "AIzaSyAiRuLBU1Z2gDuULRgRNvfXBEO90cTBFV4"
api_key = "AIzaSyDCqBET4wUKxwOeSoYxD_CYwnUoZhYQFvI"
require "base64"
require 'net/http'
require 'json'

# Base 64 the input image
b64_data = Base64.encode64(File.open(ARGV[0], "rb").read)

# Stuff we need
content_type = "Content-Type: application/json"
url = "https://vision.googleapis.com/v1/images:annotate?key=#{api_key}"
data = {
  "requests": [
    {
      "image": {
        "content": b64_data
      },
      "features": [
        {
          "type": "FACE_DETECTION",
          "maxResults": 1
        }
      ]
    }
  ]
}.to_json

# Make the request
url = URI(url)
req = Net::HTTP::Post.new(url, initheader = {'Content-Type' =>'application/json'})
req.body = data
res = Net::HTTP.new(url.host, url.port)
res.use_ssl = true

# res.set_debug_output $stderr

res.start do |http| 
  puts "Querying Google for image: #{ARGV[0]}"
  resp = http.request(req)
  p resp
  json = JSON.parse(resp.body)
  puts json
end
