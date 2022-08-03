require './lib/sortable'

describe Sortable do
  before do
    game_path = './data/games_dummy_small.csv'
    team_path = './data/teams_dummy_small.csv'
    game_teams_path = './data/game_teams_dummy_small.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  it '#sort_games_by_season' do
    expect(@stat_tracker.league.sort_games_by_season(@stat_tracker.league.all_games).keys).to eq(
      ["20132014", "20142015", "20152016"]
    )
    expect(@stat_tracker.league.sort_games_by_season(@stat_tracker.league.all_games)["20142015"].first.game_id).to eq(
      "2014020868"
    )
  end

  it '#goals_by_season' do
    expect(@stat_tracker.league.goals_by_season).to eq({"20132014" => [1], "20142015" => [6,1], "20152016" => [6,5]})
  end

  it '#away_team_by_goals' do
    expect(@stat_tracker.league.away_team_by_goals).to eq({"3" => [2, 2], "6" => [2]})
  end

  it '#home_team_by_goals' do
    expect(@stat_tracker.league.home_team_by_goals).to eq({"6" => [3, 3]})
  end

  it '#game_team_group_by_team' do
    expect(@stat_tracker.league.game_team_grouped_by_team("3").length).to eq(2)
  end

  it '#game_team_group_by_season' do
    expect(@stat_tracker.league.game_team_group_by_season("20122013")[2].game_id).to eq("2012030222")
  end

end
