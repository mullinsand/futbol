require './lib/stat_tracker'

describe StatTracker do
  before(:all) do
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  it "exists" do
    expect(@stat_tracker).to be_an_instance_of StatTracker
  end

  it "#highest_total_score" do
    expect(@stat_tracker.highest_total_score).to eq 6
  end

  it '#lowest_total_score' do
    expect(@stat_tracker.lowest_total_score).to eq 1
  end

  it '#average_goals_per_game' do
    expect(@stat_tracker.average_goals_per_game).to eq(3.85)
  end
  
  it '#count_of_games_by_season' do
    expected = {
      "20122013" => 2,
      "20132014" => 6,
      "20142015" => 7,
      "20152016" => 5
    }

    expect(@stat_tracker.count_of_games_by_season).to eq(expected)
  end

  it '#count_of_teams' do
    expect(@stat_tracker.count_of_teams). to eq (20)
  end
end
