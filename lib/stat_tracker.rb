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

  def average_goals_by_season
    goals_season_hash = Hash.new
    @all_data_hash[:games].each do |row|
      home_goals = row[:home_goals].to_i
      away_goals = row[:away_goals].to_i
      if !goals_season_hash[row[:season]]
        goals_season_hash[row[:season]] = []
      end
      goals_season_hash[row[:season]] << (home_goals + away_goals)
    end
    avg_goals_by_season = Hash.new(0)
    goals_season_hash.each do |season, total_scores|
      avg_goals_by_season[season] = (total_scores.sum(0.0) / total_scores.length).round(2)
    end
    avg_goals_by_season
  end

  def percentage_home_wins
    home_wins = 0.0
    total_games = 0.0
    @all_data_hash[:games].each do |row|
      if row[:home_goals].to_i > row[:away_goals].to_i
        home_wins += 1
      end
      total_games += 1
    end
    percentage = (home_wins / total_games).round(2)
  end

  def percentage_vistor_wins
    vistor_wins = 0.0
    total_games = 0.0
    @all_data_hash[:games].each do |row|
      if row[:away_goals].to_i > row[:home_goals].to_i
        vistor_wins += 1
      end
      total_games += 1
    end
    vistor_percentage = (vistor_wins / total_games).round(2)
  end

  def percentage_ties
    ties = 0.0
    total_games = 0.0
    @all_data_hash[:games].each do |row|
      if row[:away_goals].to_i == row[:home_goals].to_i
        ties += 1
      end
      total_games += 1
    end
    tie_percentage = (ties / total_games).round(2)
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

  def highest_scoring_visitor
    away_team_goals_hash = Hash.new
    @all_data_hash[:game_teams].each do |row|
      if !away_team_goals_hash[row[:team_id]]
        away_team_goals_hash[row[:team_id]] = []
      end
      if row[:hoa] == "away"
        away_team_goals_hash[row[:team_id]] << row[:goals].to_i
      end
    end
    avg_away_team_goals_hash = Hash.new(0)
    away_team_goals_hash.each do |team, goals|
      avg_away_team_goals_hash[team] = (goals.sum(0.0) / goals.length).round(2)
    end
    highest_away_team_id = avg_away_team_goals_hash.max_by do |team, avg_goals|
      avg_goals
    end[0]
    highest_away_team_name = nil
    @all_data_hash[:teams].each do |row|
      if row[:team_id] == highest_away_team_id
        highest_away_team_name = row[:teamname]
      end
    end
    highest_away_team_name
  end

  def lowest_scoring_visitor
    away_team_goals_hash = Hash.new
    @all_data_hash[:game_teams].each do |row|
      if !away_team_goals_hash[row[:team_id]]
        away_team_goals_hash[row[:team_id]] = []
      end
      if row[:hoa] == "away"
        away_team_goals_hash[row[:team_id]] << row[:goals].to_i
      end
    end
    avg_away_team_goals_hash = Hash.new(0)
    away_team_goals_hash.each do |team, goals|
      avg_away_team_goals_hash[team] = (goals.sum(0.0) / goals.length).round(2)
    end
    lowest_away_team_id = avg_away_team_goals_hash.min_by do |team, avg_goals|
      avg_goals
    end[0]
    lowest_away_team_name = nil
    @all_data_hash[:teams].each do |row|
      if row[:team_id] == lowest_away_team_id
        lowest_away_team_name = row[:teamname]
      end
    end
    lowest_away_team_name
  end

  def highest_scoring_home_team
    home_team_goals_hash = Hash.new
    @all_data_hash[:game_teams].each do |row|
      if !home_team_goals_hash[row[:team_id]]
        home_team_goals_hash[row[:team_id]] = []
      end
      if row[:hoa] == "home"
        home_team_goals_hash[row[:team_id]] << row[:goals].to_i
      end
    end
    avg_home_team_goals_hash = Hash.new(0)
    home_team_goals_hash.each do |team, goals|
      if goals != []
        avg_home_team_goals_hash[team] = (goals.sum(0.0) / goals.length).round(2)
      end
    end
    highest_home_team_id = avg_home_team_goals_hash.max_by do |team, avg_goals|
      avg_goals
    end[0]
    highest_home_team_name = nil
    @all_data_hash[:teams].each do |row|
      if row[:team_id] == highest_home_team_id
        highest_home_team_name = row[:teamname]
      end
    end
    highest_home_team_name
  end

  def lowest_scoring_home_team
    home_team_goals_hash = Hash.new
    @all_data_hash[:game_teams].each do |row|
      if !home_team_goals_hash[row[:team_id]]
        home_team_goals_hash[row[:team_id]] = []
      end
      if row[:hoa] == "home"
        home_team_goals_hash[row[:team_id]] << row[:goals].to_i
      end
    end
    avg_home_team_goals_hash = Hash.new(0)
    home_team_goals_hash.each do |team, goals|
      if goals != []
        avg_home_team_goals_hash[team] = (goals.sum(0.0) / goals.length).round(2)
      end
    end
    lowest_home_team_id = avg_home_team_goals_hash.min_by do |team, avg_goals|
      avg_goals
    end[0]
    lowest_home_team_name = nil
    @all_data_hash[:teams].each do |row|
      if row[:team_id] == lowest_home_team_id
        lowest_home_team_name = row[:teamname]
      end
    end
    lowest_home_team_name
  end

  def most_tackles(season)
    games_by_season = []
    game_id =[]
    team_id_tackles = Hash.new(0)
    @all_data_hash[:game_teams].each do |row|
      if row[:game_id][0..3] == season[0..3]
        games_by_season << row
      end
    end
    @all_data_hash[:game_teams].each do |row|
      games_by_season.each do |games_row|
          if row[:game_id][0..3] == games_row[:game_id][0..3]
            team_id_tackles[row[:team_id]] += row[:tackles].to_i
          end
      end
    end

    team_with_most_tackles = nil
    greatest_tackles_and_team_id = team_id_tackles.sort_by { |team_id, tackles| tackles}.last
    @all_data_hash[:teams].each do |row|

      if row[:team_id] == greatest_tackles_and_team_id[0]
        team_with_most_tackles = row[:teamname]
      end
    end

    team_with_most_tackles
  end

  def fewest_tackles(season)
    games_by_season = []
    game_id =[]
    team_id_tackles = Hash.new(0)
    @all_data_hash[:game_teams].each do |row|
      if row[:game_id][0..3] == season[0..3]
        games_by_season << row
      end
    end
    @all_data_hash[:game_teams].each do |row|
      games_by_season.each do |games_row|
          if row[:game_id][0..3] == games_row[:game_id][0..3]
            team_id_tackles[row[:team_id]] += row[:tackles].to_i
          end
      end
    end

    team_with_least_tackles = nil
    least_tackles_and_team_id = team_id_tackles.sort_by { |team_id, tackles| tackles}.first
    @all_data_hash[:teams].each do |row|

      if row[:team_id] == least_tackles_and_team_id[0]
        team_with_least_tackles = row[:teamname]
      end
    end

    team_with_least_tackles
  end
end
