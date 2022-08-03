require './lib/stat_tracker2'
require './lib/league'

class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link


  def initialize(info)
    @game_id = info[:game_id]
    @season = info[:season]
    @type = info[:type]
    @date_time = info[:date_time]
    @away_team_id = info[:away_team_id]
    @home_team_id = info[:home_team_id]
    @away_goals = info[:away_goals]
    @home_goals = info[:home_goals]
    @venue = info[:venue]
    @venue_link = info[:venue_link]
  end

  def did_team_win?(team_id)
    if @away_team_id == team_id
      @away_goals > @home_goals
    elsif @home_team_id == team_id
      @home_goals > @away_goals
    else
      "it was a tie or that team didn't win"
    end
  end

  def opponent_id(team_id)
    if @away_team_id == team_id
      @home_team_id
    elsif @home_team_id == team_id
      @away_team_id
    else
      "that team didn't play"
    end
  end

  def home_win?
    @home_goals.to_i > @away_goals.to_i
  end

  def visitor_win?
    @home_goals.to_i < @away_goals.to_i
  end

  def tie?
    @home_goals.to_i == @away_goals.to_i
  end

  def total_goals
    @home_goals.to_i + @away_goals.to_i
  end
end
