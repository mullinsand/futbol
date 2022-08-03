module Sortable
  #games
  def sort_games_by_season(games)
    games.group_by do |game|
      game.season
    end
  end

  def goals_by_season
    goals_by_season = Hash.new {|h,k| h[k]=[]}
    @all_games.each do |game|
      goals_by_season[game.season] << game.total_goals
    end
    goals_by_season
  end

  def away_team_by_goals
    away_team_by_goals = Hash.new {|h,k| h[k]=[]}
    @all_game_teams.each do |game|
      away_team_by_goals[game.team_id] << game.goals.to_i if game.hoa == "away"
    end
    away_team_by_goals
  end

  def home_team_by_goals
    home_team_by_goals = Hash.new {|h,k| h[k]=[]}
    @all_game_teams.each do |game|
      home_team_by_goals[game.team_id] << game.goals.to_i if game.hoa == "home"
    end
    home_team_by_goals
  end

  #game_teams
  def game_team_grouped_by_team(given_team_id)
    @all_game_teams.group_by do |game|
      game.team_id
    end[given_team_id]
  end

  def data_sorted_by_season(game_team_data)
    data_set_by_teams = game_team_data.group_by do |game|
      game.game_id[0..3]
    end
  end

  def game_team_group_by_season(season)
    @all_game_teams.group_by do |game|
      game.game_id[0..3]
    end[season[0..3]]
  end
end
