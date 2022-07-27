require 'csv'

class StatTracker
  def self.from_csv(locations)
    all_data_hash = Hash.new{ |h, k| h[k] = [] }
    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |row|
      all_data_hash[:games] << row
    end
    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      all_data_hash[:teams] << row
    end
    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      all_data_hash[:game_teams] << row
    end
  new(all_data_hash)
  end

  def initialize(all_data_hash)
    @all_data_hash = all_data_hash
  end

  def highest_total_score
    @all_data_hash[:games].map do |row|
      home_goals = row[:home_goals].to_i
      away_goals = row[:away_goals].to_i
      home_goals + away_goals
    end.max
  end

  def lowest_total_score
    total_scores = @all_data_hash[:games].map do |row|
      home_goals = row[:home_goals].to_i
      away_goals = row[:away_goals].to_i
      home_goals + away_goals
    end
    total_scores.min
  end

  def average_goals_per_game
    total_scores = @all_data_hash[:games].map do |row|
      home_goals = row[:home_goals].to_i
      away_goals = row[:away_goals].to_i
      home_goals + away_goals
    end
    (total_scores.sum(0.0) / total_scores.length).round(2)
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)

    @all_data_hash[:games].each do |row|
      games_by_season[row[:season]] += 1
    end
    games_by_season
  end

  def count_of_teams
    team_names = []

    @all_data_hash[:teams].each do |row|
      team_names << row[:teamname]
    end
    team_names.uniq.count
  end

  def best_offense
    goals_per_team = Hash.new()

    @all_data_hash[:game_teams].each do |row|
      if !goals_per_team[row[:team_id]]
        goals_per_team[row[:team_id]] = []
        goals_per_team[row[:team_id]] << row[:goals].to_i
      else
        goals_per_team[row[:team_id]] << row[:goals].to_i
      end
    end
    goals_per_team

    team_ids = goals_per_team.keys
    goals_scored = goals_per_team.values

    averages = []
    goals_scored.each do |team_goals|
      averages << team_goals.sum(0.0) / team_goals.length.round(2)
    end
    averages

    team_averages = Hash[team_ids.zip(averages)]
    highest_average = team_averages.max_by{|k, v| v}

    @all_data_hash[:teams].find do |team|
      team[:team_id].to_i == highest_average[0].to_i
    end[:teamname]
  end

  def worst_offense
    goals_per_team = Hash.new()

    @all_data_hash[:game_teams].each do |row|
      if !goals_per_team[row[:team_id]]
        goals_per_team[row[:team_id]] = []
        goals_per_team[row[:team_id]] << row[:goals].to_i
      else
        goals_per_team[row[:team_id]] << row[:goals].to_i
      end
    end
    goals_per_team

    team_ids = goals_per_team.keys
    goals_scored = goals_per_team.values

    averages = []
    goals_scored.each do |team_goals|
      averages << team_goals.sum(0.0) / team_goals.length.round(2)
    end
    averages

    team_averages = Hash[team_ids.zip(averages)]
    lowest_average = team_averages.min_by{|k, v| v}

    @all_data_hash[:teams].find do |team|
      team[:team_id].to_i == lowest_average[0].to_i
    end[:teamname]
  end
end
