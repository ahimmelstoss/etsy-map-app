require 'keys'

class EtsyMapApp < Sinatra::Base

  set :public_folder => "public", :static => true

  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  before do
    Etsy.api_key = API_KEY
    Etsy.api_secret = SECRET_KEY
    Etsy.environment = :production
    Etsy.protocol = 'https'
    Etsy.callback_url = 'http://localhost:9292/authorize'
  end

  get '/' do
    if session[:access_token].nil? && session[:access_secret].nil?
      erb :index, :layout => false
    else
      redirect '/map'
    end
  end

  get '/login' do
    request_token = Etsy.request_token
    session[:request_token]  = request_token.token
    session[:request_secret] = request_token.secret
    redirect Etsy.verification_url
  end

  get '/authorize' do
    access_token = Etsy.access_token(
      session[:request_token],
      session[:request_secret],
      params[:oauth_verifier]
    )
    session[:access_token] = access_token.token
    session[:access_secret] = access_token.secret
    redirect '/map'
    # access_token.token and access_token.secret can now be saved for future API calls
  end

  get "/map" do
    # TODO: redirect if user is not authenticated
    set_etsy_mock_data
    access = {
      :access_token => session[:access_token], 
      :access_secret => session[:access_secret]
    }
    # "User" has a convenience method that can be used to get a user:
    @user = Etsy.myself(access[:access_token], access[:access_secret])
    # More general way to perform any Etsy API request (retrieving information given user.id, integer, taken from the previous call):
    @user = Etsy::Request.get('/users/' + @user.id.to_s, access.merge(:limit => 5)).to_hash["results"]
    # user -> user_id -> some method that gets orderss from user_id -> take all those orders and iterate over them -> get all shop_ids -> some method that gets location from shop_id/user_id -> iterate over them -> get all locations. this is the data structure that i pass to the map.erb (then to the map.js, which renders it through the maps api)
    ap @user
    erb :map, :layout => false
  end

  def set_etsy_mock_data
    @etsy_mock_data = [
      {:location => 'Beijing, China',
       :shop_name => 'freestickersdecal',
       :purchase_date => '2013-12-15',},
      {:location => 'Brightwood, Oregon',
       :shop_name => 'MtHoodWoodWorks',
       :purchase_date => '2013-05-15'},
      {:location => 'Sofia, Bulgaria',
       :shop_name => 'StudioPapilio',
       :purchase_date => '2013-04-05'}
    ]
  end
end
