class League
  attr_reader :all_games, :all_teams, :all_game_teams

  def initialize(all_games, all_teams, all_game_teams)
    @all_games = all_games
    @all_teams = all_teams
    @all_game_teams = all_game_teams
  end

  def total_goals
    @all_games.map do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end
  end

  def games_by_season
    games_by_season = Hash.new(0)
    @all_games.each do |game|
      games_by_season[game.season] += 1
    end
    games_by_season
  end

  def team_names
    @all_teams.map do |team|
      team.team_name
    end.uniq
  end

  def goals_by_team_id
    goals_by_team_id = Hash.new {|h,k| h[k]=[]}
    @all_game_teams.each do |game|
      goals_by_team_id[game.team_id] << game.goals.to_i
    end
    goals_by_team_id
  end

  def avg_goals_by_team_id
    avg_goals_by_team_id = Hash.new(0)
    goals_by_team_id.each do |team_id, goals|
      avg_goals_by_team_id[team_id] = (goals.sum(0.0) / goals.length).round(2)
    end
    avg_goals_by_team_id
  end

  def team_id_to_team_name(team_id)
    @all_teams.find do |team|
      team.team_id == team_id
    end.team_name
  end

  def game_team_group_by_season(season)
    @all_game_teams.group_by do |game|
      game.game_id[0..3]
    end[season[0..3]]
  end

  def coaches_by_win_percentage(season)
    games_team_sorted = game_team_group_by_season(season)
    data_set_by_head_coach = games_team_sorted.group_by do |game|
      game.head_coach
    end
    coaches_by_win_percentage = Hash.new{|h,k| h[k] = 0}
    data_set_by_head_coach.each do |coach, games|
      game_outcomes_by_stat = {
        wins: 0,
        ties: 0,
        total_games: 0
      }
      games.each do |game|
        game_outcomes_by_stat[:wins] += 1 if game.result == "WIN"
        game_outcomes_by_stat[:ties] += 1 if game.result == "TIE"
        game_outcomes_by_stat[:total_games] += 1
      end
      coaches_by_win_percentage[coach] = ((game_outcomes_by_stat[:wins].to_f / game_outcomes_by_stat[:total_games])*100).round(2)
    end
    coaches_by_win_percentage
  end

  def teams_by_accuracy(season)
    games_team_sorted = game_team_group_by_season(season)
    data_set_by_teams = games_team_sorted.group_by do |game|
      game.team_id
    end
    teams_by_accuracy = Hash.new{|h,k| h[k] = 0}
    data_set_by_teams.each do |team, games|
      game_outcomes_by_stat = {
        shots: 0,
        goals: 0
      }
      games.each do |game|
        game_outcomes_by_stat[:shots] += game.shots.to_i
        game_outcomes_by_stat[:goals] += game.goals.to_i
      end
      teams_by_accuracy[team] = (game_outcomes_by_stat[:goals].to_f / game_outcomes_by_stat[:shots]).round(5)
    end
    teams_by_accuracy
  end

  def teams_by_tackles(season)
    games_team_sorted = game_team_group_by_season(season)
    data_set_by_teams = games_team_sorted.group_by do |game|
      game.team_id
    end
    teams_by_tackles = Hash.new{|h,k| h[k] = 0}
    data_set_by_teams.each do |team, games|
      game_outcomes_by_stat = {
        tackles: 0,
      }
      games.each do |game|
        game_outcomes_by_stat[:tackles] += game.tackles.to_i
      end
      teams_by_tackles[team] = game_outcomes_by_stat[:tackles]
    end
    teams_by_tackles
  end

  def find_team(given_team_id)
    selected_team = @all_teams.select do |team|
      team.team_id == given_team_id
    end[0]
  end

  def display_team_info(selected_team)
    team_info = {
      "team_id" => selected_team.team_id,
      "franchise_id" => selected_team.franchise_id,
      "team_name" => selected_team.team_name,
      "abbreviation" => selected_team.abbreviation,
      "link" => selected_team.link
    }
  end

  def game_team_grouped_by_team(given_team_id)
    @all_game_teams.group_by do |game|
      game.team_id
    end[given_team_id]
  end

  def data_sorted_by_season(data)
    data_set_by_teams = data.group_by do |game|
      game.game_id[0..3]
    end
  end

  def seasons_by_wins(given_team_id)
    teams_games = game_team_grouped_by_team(given_team_id)
    team_games_by_season = data_sorted_by_season(teams_games)
    seasons_by_win_percentage = Hash.new{|h,k| h[k] = 0}
    team_games_by_season.each do |season, games|
      full_season = games.first.game_id[0..3]+games.first.game_id[0..2]+(games.first.game_id[3].to_i + 1).to_s
      game_outcomes_by_stat = {
        wins: 0,
        ties: 0,
        total_games: 0
      }
      games.each do |game|
        game_outcomes_by_stat[:wins] += 1 if game.result == "WIN"
        game_outcomes_by_stat[:ties] += 1 if game.result == "TIE"
        game_outcomes_by_stat[:total_games] += 1
      end
      seasons_by_win_percentage[full_season] = (game_outcomes_by_stat[:wins].to_f / game_outcomes_by_stat[:total_games]).round(5)
    end
    seasons_by_win_percentage
  end

  def wins_losses_tally(given_team_id)
    teams_games = game_team_grouped_by_team(given_team_id)
    all_games_tally = {
      wins: 0,
      ties: 0,
      total_games: 0
    }
    teams_games.each do |game|
        all_games_tally[:wins] += 1 if game.result == "WIN"
        all_games_tally[:ties] += 1 if game.result == "TIE"
        all_games_tally[:total_games] += 1
      end
    all_games_tally
  end
end
