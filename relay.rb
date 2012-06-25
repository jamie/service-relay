require 'rubygems'
require 'bundler/setup'

require './lib/environment'

helpers do
  def protected!
    return if ENV['RACK_ENV'] == 'development'
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ENV['BASIC_AUTH'].split(':')
  end

end

before do
  @hipchat = Hipchat.new(ENV['HIPCHAT_TOKEN'], ENV['HIPCHAT_ROOM'])
  @github = Github.new(ENV['GITHUB_TOKEN'], ENV['GITHUB_REPO'])
  @pivotal = Pivotal.new(ENV['PIVOTAL_TOKEN'])

  @services = {:github => @github, :hipchat => @hipchat, :pivotal => @pivotal}
end

get '/' do
  erb :index
end

WEBHOOKS = {
  'pivotal' => PivotalPing
}
WEBHOOK_ACTIONS = {
  'pivotal' => [
    lambda {|ping, services|
      # Inform hipchat of all non-edit actions
      next if ping.edited?
      services[:hipchat].send('Pivotal Tracker', ping.enhance!.description)
    },
    lambda {|ping, services|
      # When a non-chore is started, auto-create a topic branch for it
      story = ping.stories.first
      next unless ping.started? && story && !story.chore?
      branch = services[:github].create_branch(story.name)
      msg = "Branched *#{branch.name}* - #{branch.url}"
      story.add_note(msg)
    },
    lambda {|ping, services|
      Salesforce.new.process_update(ping)
    }
  ]
}

post '/:service/webhook' do
  ping = WEBHOOKS[params[:service]].new(request.body.read)
  WEBHOOK_ACTIONS[params[:service]].each do |action|
    action.call(ping, @services)
  end
  'OK'
end

get '/salesforce/to/pivotal' do
  protected!
  @cases = Salesforce.new.get_cases
  content_type 'application/json'
  SalesforcePivotalFormatter.new(@cases).to_xml
end

__END__

@@ index
<html><body>No content</body></html>

