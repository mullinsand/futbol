# runner.rb
require './lib/stat_tracker'

game_path = './data/games_dummy.csv'
team_path = './data/teams_dummy.csv'
game_teams_path = './data/game_teams_dummy.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry
