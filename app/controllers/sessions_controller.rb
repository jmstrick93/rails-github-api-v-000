class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]

  def create
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.params['client_id'] = ENV['GITHUB_CLIENT_ID']
      req.params['client_secret'] = ENV['GITHUB_SECRET']
      req.params['code'] = params[:code]
      req.headers['Accept'] = 'application/json'
    end

    results = JSON.parse(resp.body)
    session[:token] = results['access_token']
    redirect_to '/'
  end
end
