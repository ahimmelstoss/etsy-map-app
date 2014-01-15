require_relative "spec_helper"
require_relative "../etsy_map_app.rb"

def app
  EtsyMapApp
end

describe EtsyMapApp do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
