require './lib/stat_tracker2'

describe StatTracker do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

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
    expect(@stat_tracker.highest_total_score).to eq 11
  end

end
#   it '#lowest_total_score' do
#     expect(@stat_tracker.lowest_total_score).to eq 0
#   end
#
#   it '#returns the percentage of home team wins' do
#     expect(@stat_tracker.percentage_home_wins).to eq 0.44
#   end
#
#   it '#returns the percentage of visitor team wins' do
#     expect(@stat_tracker.percentage_vistor_wins).to eq 0.36
#   end
#
#   it '#returns the percentage of games tied' do
#     expect(@stat_tracker.percentage_ties).to eq 0.20
#   end
#
#   it "#most_tackles" do
#     expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
#     expect(@stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
#   end
#
# end
