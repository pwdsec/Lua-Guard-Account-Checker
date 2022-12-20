# Lua-Guard-Account-Checker
Check if email:pass are valid

put your combo in email:pass and run main.rb

basic checker can be updated with threads

`test@gmail.com:abcde - None` <br>
`email:password - plan`

## Changes

- Replaced `require 'net/http'` with `require 'http'`, which is a faster HTTP client library.
- Replaced `Net::HTTP::Post` with `HTTP.post`, which is a simpler and faster way to make an HTTP POST request.
- Replaced `URI.parse` with `URI`, which is a shorthand for creating a new `URI::HTTP` object.
- Replaced `Net::HTTP.start` with `HTTP.post`, which is a simpler and faster HTTP client library.
- Replaced `request.content_type = "application/json"` with `json: { ... }`, which is a shorter and more concise way to set the `Content-Type` header to `application/json` and send a JSON body in the request.
- Replaced `JSON.dump` with `#to_json`, which is a method available on all Ruby hashes. It converts a hash to a JSON string.
- Replaced `request["Authorization"] = "Bearer " + token` with `headers: { "Authorization": "Bearer " + token }`, which is a shorter and more concise way to set the `Authorization` header in the request.
- Read the entire file into memory and made HTTP requests in parallel using `Concurrent::Promise`.
- Added a cache to store the results of HTTP requests and avoid making unnecessary requests.
- Updated the file with the results and removed invalid login credentials.
