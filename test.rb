require 'rest-client'
require 'json'

api_gateway_url = 'https://atdbejb5l7.execute-api.us-east-1.amazonaws.com/prod'
request_payload = {}
headers = {
  "Content-Type": 'application/json'
}

begin
  RestClient.post("#{api_gateway_url}/reset-redis", request_payload.to_json, headers)

  loop do
    response = RestClient.post("#{api_gateway_url}/charge-request-redis", request_payload.to_json, headers)
    body = JSON.parse(response.body)
    puts "Response code: #{response.code}"
    puts "Response body: #{response.body}"

    break unless body['isAuthorized']
  end
rescue RestClient::ExceptionWithResponse => e
  puts "Error response code: #{e.response.code}"
  puts "Error response body: #{e.response.body}"
end
