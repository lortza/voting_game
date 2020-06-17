# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[index new edit update destroy]
  before_action :set_game, only: %i[show edit update destroy players_ready]

  def index
    @current_games = current_user.games
                                 .current
                                 .order('created_at DESC')
    @past_games = current_user.games
                              .past
                              .order('created_at DESC')
                              .paginate(page: params[:page], per_page: 30)
  end

  def new
    @game = current_user.games.new
    10.times { @game.players.build }
  end

  def show
    cookies.delete(:player_id)
  end

  def edit
    # authorize(@game)

    5.times { @game.players.build }
  end

  def create
    @game = current_user.games.new

    if @game.save
      @game.generate_rounds(params[:adult_content_permitted])
      redirect_to games_url
    else
      render :new
    end
  end

  def update
    if @game.update(game_params)
      redirect_to games_url
    else
      render :edit
    end
  end

  def destroy
    @game.destroy

    cookies.delete(:player_id)
    notice = "Game at #{@game.date} was successfully deleted."
    redirect_to games_url, notice: notice
  end

  def players_ready
    @game.update(players_ready: true)
    redirect_to game_players_url(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:user_id,
                                 :players_ready,
                                 players_attributes: [:id, :name, :_destroy])
  end
end
