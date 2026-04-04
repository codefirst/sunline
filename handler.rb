require_relative "config/boot"
require "lamby"
require_relative "config/application"
require_relative "config/environment"

$app = Rack::Builder.new { run Rails.application }.to_app

def handler(event:, context:)
  response = Lamby.handler $app, event, context, rack: :http
  body = response[:body]
  return response unless body

  body = body.force_encoding(Encoding::UTF_8)
  if body.valid_encoding?
    response[:body] = body
  else
    require "base64"
    response[:body] = Base64.strict_encode64(body.force_encoding(Encoding::BINARY))
    response[:isBase64Encoded] = true
  end

  response
end

