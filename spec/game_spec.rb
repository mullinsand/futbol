require './lib/game'

RSpec.describe Game do
  before do
    info ={
      game_id: "2012030221",
      season: "20122013",
      type: "Postseason",
      date_time: "5/16/13",
      away_team_id: "3",
      home_team_id: "6",
      away_goals: "2",
      home_goals: "3",
      venue: "Toyota Stadium",
      venue_link: "/api/v1/venues/null"
    }
    @game = Game.new(info)
  end

  describe '#initialize' do
    it 'exists' do

      expect(@game).to be_instance_of(Game)
    end
  end

  describe '@attributes' do
    it 'has a game id' do

      expect(@game.game_id).to eq("2012030221")
    end

    it 'has a season' do

      expect(@game.season).to eq("20122013")
    end

    it 'has a type' do

      expect(@game.type).to eq("Postseason")
    end

    it 'has a date_time' do

      expect(@game.date_time).to eq("5/16/13")
    end

    it 'has an away_team_id' do

      expect(@game.away_team_id).to eq("3")
    end

    it 'has a home_team_id' do

      expect(@game.home_team_id).to eq("6")
    end

    it 'has away goals' do

      expect(@game.away_goals).to eq("2")
    end

    it 'has home goals' do

      expect(@game.home_goals).to eq("3")
    end

    it 'has a venue' do

      expect(@game.venue).to eq("Toyota Stadium")
    end

    it 'has a venue link' do

      expect(@game.venue_link).to eq("/api/v1/venues/null")
    end
  end

  describe '#home_win?' do
    it 'returns true with a home win' do

      expect(@game.home_win?).to be true
    end
  end

  describe '#visitor_win?' do
    it 'returns true with a visitor win' do

      expect(@game.visitor_win?).to be false
    end
  end

  describe '#tie' do
    it "returns true with a tie" do

      expect(@game.tie?).to be false
    end
  end

  describe '#opponent_id' do
    it 'gives the opponent based on a team_id argument' do
      expect(@game.opponent_id("3")).to eq("6")
      expect(@game.opponent_id("6")).to eq("3")
      expect(@game.opponent_id("7")).to eq("that team didn't play")
    end
  end

  describe '#total_goals' do
    it 'adds home goals and away goals' do
      expect(@game.total_goals).to eq(5)
    end
  end
end
