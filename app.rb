def get_scoreboard(date=nil, teams=[])
  url = "https://www.mysportsfeeds.com"
  options = {}
  conn = Faraday.new(:url => url)
  conn.basic_auth(ENV['MY_SPORTS_FEEDS_USERNAME'], ENV['MY_SPORTS_FEEDS_PASSWORD'])

  route = "/api/feed/pull/mlb/current/scoreboard.json"

  if !date.nil?
    options[:fordate] = date.strftime("%Y%m%d")
  end

  if !teams.empty?
    options[:team] = teams.join(',')
  end

  resp = conn.get(route, options)

  resp.body
end

def did_win?(scoreboard, team)
  did_win = false
  scoreboard["scoreboard"]["gameScore"].each do |game|
    if game["game"]["awayTeam"]["Abbreviation"] == team
      if game["awayScore"] > game["homeScore"]
        did_win = true
      end
    else
      if game["homeScore"] > game["awayScore"]
        did_win = true
      end
    end
  end
  return did_win
end

get '/' do
  date = Date.new(2017,6,23)
  scoreboard = JSON.parse(get_scoreboard(date, ['COL']))

  haml :home, :locals => {:did_win=>did_win?(scoreboard, "COL")}
end

namespace '/api' do

  before do
    content_type 'application/json'
  end

  get '/rockies' do
    date = Date.new(2017,6,23)
    scoreboard = JSON.parse(get_scoreboard(date, ['COL']))
    did_win?(scoreboard, "COL").to_json
  end
end
