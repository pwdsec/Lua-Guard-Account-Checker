# Lua-Guard-Account-Checker
Check if email:pass are valid

put your combo in email:pass and run main.rb

basic checker can be updated with threads

`test@gmail.com:abcde - None` <br>
`email:password - plan`

# Changelogs

I replaced URI.parse with URI, which is a shorthand for creating a new URI::HTTP object.<br>
I replaced Net::HTTP.start with the simpler Net::HTTP.post_form, which is more appropriate for this scenario where we are only making a single POST request.<br>
I replaced JSON.dump with #to_json, which is a method available on all Ruby hashes.<br>
