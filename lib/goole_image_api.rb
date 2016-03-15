require "json"
require "base64"
require "net/http"

module GoogleImageAPI
  def self.request(filepath)
    # Base 64 the input image
    b64_data = Base64.encode64(File.open(filepath, "rb").read)

    # Stuff we need
    content_type = "Content-Type: application/json"
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{api_key}"
    data = {
      "requests" => [
        {
          "image" => {
            "content" => b64_data
          },
          "features" => [
            {
              "type" => "FACE_DETECTION",
              "maxResults" => 1
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

    json = res.start do |http| 
      resp = http.request(req)
      JSON.parse(resp.body)
    end
  end

  def self.api_key
    ENV["GOOGLE_API_KEY"]
  end
end
