# ======================= Helpers =============================================

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

  if resp.status == 200
    return JSON.parse(resp.body)
  else
    return false
  end
end

def did_score_seven_runs?(scoreboard, team)
  did_score_seven_runs = false
  if scoreboard
    scoreboard["scoreboard"]["gameScore"].each do |game|
      if game["game"]["awayTeam"]["Abbreviation"] == team
        if game["awayScore"].to_i >= 7
          did_score_seven_runs = true
        end
      elsif game["game"]["homeTeam"]["Abbreviation"] == team
        if game["homeScore"].to_i >= 7
          did_score_seven_runs = true
        end
      end
    end
  end
  return did_score_seven_runs
end

# ======================= Routes ==============================================

get '/' do
  date = Date::today.prev_day
  scoreboard = get_scoreboard(date, ['COL'])

  haml :home, :locals => {
    :did_score_seven_runs=>did_score_seven_runs?(scoreboard, "COL")
  }
end

# ======================= API Routes ==========================================

namespace '/api' do
  get '/rockies.json' do
    date = Date::today.prev_day
    scoreboard = get_scoreboard(date, ['COL'])
    json :did_score_seven_runs => did_score_seven_runs?(scoreboard, "COL")
  end
end
