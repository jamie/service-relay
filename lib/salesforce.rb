class Salesforce
  OAUTH_ENDPOINT = "https://login.salesforce.com/services/oauth2/authorize"
  TOKEN_ENDPOINT = "https://login.salesforce.com/services/oauth2/token"

  def initialize
    login!
  end

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
    url = "https://na4-api.salesforce.com/services/data/v24.0/query/"
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
    JSON.parse(@response.body)["records"]
  end

  def session_id
    @auth_response["access_token"]
  end
end


