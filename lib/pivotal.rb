require 'httparty'

class Pivotal
  include HTTParty
  base_uri 'https://www.pivotaltracker.com/services/v3'
  format :xml

  def initialize(token)
    @token = token
  end

  def get(path, options={})
    options[:headers] ||= {}
    options[:headers]['X-TrackerToken'] = @token
p [path, options]
    self.class.get(path, options)
  end

  def post(path, options={})
    options[:headers] ||= {}
    options[:headers]['X-TrackerToken'] = @token
    self.class.post(path, options)
  end
end
