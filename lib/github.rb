require 'httparty'
require 'ostruct'

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

  def post(path, options={})
    options[:query] ||= {}
    options[:query][:access_token] = @token
    self.class.post(path, options)
  end

  def branches
    heads = get("/repos/#{@repo}/git/refs/heads").body
    JSON.parse(heads).inject({}){|h, entry|
      branch = entry["ref"].split('/').last
      h[branch] = entry["object"]["sha"]
      h
    }
  end

  def create_branch(name, from='master')
    name = sanitize(name)
    body = {
      'ref' => "refs/heads/#{name}",
      'sha' => branches[from]
    }.to_json
    post("/repos/#{@repo}/git/refs", :body => body)
    OpenStruct.new(:url => "https://github.com/#{@repo}/tree/#{name}", :name => name)
  end


private
  def sanitize(str)
    (str.downcase.split(/[^a-z]+/) - ['']).join('-')
  end
end
