class RepositoriesController < ApplicationController

  def index
    user_resp = Faraday.get("https://api.github.com/user") do |req|
      req.params['access_token'] = session[:token]
    end

    repos_resp = Faraday.get("https://api.github.com/user/repos") do |req|
      req.params['access_token'] = session[:token]
    end

    repos_results = JSON.parse(repos_resp.body)

    user_results = JSON.parse(user_resp.body)
    @user_login = user_results['login']
    @user_repo_names = repos_results.map{|repo| repo['name']}

  end

  def create
    new_repo_name = params[:name]
    resp = Faraday.post("https://api.github.com/user/repos") do |req|
      req.params['access_token'] = session[:token]
      req.params['name'] = new_repo_name
    end
    puts resp.headers['status']
    binding.pry

    redirect_to repositories_path
  end
end
