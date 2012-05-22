require 'httparty'

class Github
  include HTTParty
  base_uri 'https://api.github.com'
  format :json

  def initialize(token, repo)
    @token = token
    @repo = repo
  end

  def get(path, options={})
    options[:query] ||= {}
    options[:query][:access_token] = @token
    self.class.get(path, options)
  end

  def branches
    heads = get("/repos/#{@repo}/git/refs/heads").body
    JSON.parse(heads).map{|entry|
      entry["ref"].split('/').last
    }
  end


end

