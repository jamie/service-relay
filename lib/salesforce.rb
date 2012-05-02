class Salesforce
  OAUTH_ENDPOINT = "https://login.salesforce.com/services/oauth2/authorize"
  TOKEN_ENDPOINT = "https://login.salesforce.com/services/oauth2/token"
  API_BASE = "https://na4-api.salesforce.com/services/data/v24.0"

  def login!
    @auth_response ||= HTTParty.post(
      TOKEN_ENDPOINT,
      :body => {
        :grant_type    => 'password',
        :client_id     => ENV['SF_CONSUMER_KEY'],
        :client_secret => ENV['SF_CONSUMER_SECRET'],
        :username      => ENV['SF_LOGIN'],
        :password      => ENV['SF_PASSWORD'] + ENV['SF_TOKEN']
      }
    )
  end

  def get_cases
    url = "#{API_BASE}/query/"
    query = "SELECT id, subject, description, createddate, " +
      "suppliedname, status from Case where Status LIKE 'Escalated%'"
    @response = HTTParty.get(
      url,
      :query => { :q => query },
      :headers => {
        'Authorization' => "OAuth #{session_id}",
        'X-PrettyPrint' => '1'
      }
    )
    @response["records"]
  end

  def process_update(update)
    pp update
    return # Unless integration type matches
    # In theory?
    #url = "#{API_BASE}/sobjects/CaseComment"
    HTTParty.post(
      url,
      :body => {
        "ParentId" => # external id
        "IsPublished" => false,
        "CommentBody" => "An update from Pivotal Tracker!\n"+# message body
      }
      :headers => {
        'Authorization' => "OAuth #{session_id}",
        'Content-Type'  => 'application/json',
        'X-PrettyPrint' => '1'
      }
    )
  end

  def session_id
    login!
    @auth_response["access_token"]
  end
end


