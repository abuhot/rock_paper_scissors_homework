class GameController < ApplicationController
  # This action is for the bare domain. You can ignore it.
  def home
    redirect_to("/mockup.html")
  end

  # Your code goes below.

  def rps

  @user_move = params[:the_move]
  @computer_move = ["rock", "paper", "scissors"].sample

    if @user_move == @computer_move
          @outcome = "tied"
        elsif @user_move == "paper" && @computer_move == "rock"
          @outcome = "won"
        elsif @user_move == "paper" && @computer_move == "scissors"
          @outcome = "lost"
        elsif @user_move == "scissors" && @computer_move == "rock"
          @outcome = "lost"
        elsif @user_move == "scissors" && @computer_move == "paper"
          @outcome = "won"
        elsif @user_move == "rock" && @computer_move == "paper"
          @outcome = "lost"
        elsif @user_move == "rock" && @computer_move == "scissors"
          @outcome = "won"
    end

    # Adding an entry to the Move table for this turn
    m = Move.new
    m.user_move = @user_move
    m.computer_move = @computer_move
    if @outcome == "won"
      m.user_wins = 1
      m.computer_wins = 0
    elsif @outcome == "lost"
      m.user_wins = 0
      m.computer_wins = 1
    else
      m.user_wins = 0
      m.computer_wins = 0
      m.tie = 1
    end

    m.save

    # Retrieving all past moves in order to draw the log
    @all_moves = Move.all

    rock_moves = @all_moves.where({:user_move => "rock"})
    paper_moves = @all_moves.where({:user_move => "paper"})
    scissors_moves = @all_moves.where({:user_move => "scissors"})

    @rock_won = rock_moves.where({:user_wins => "1"}).count
    @rock_ties = rock_moves.where({:tie => "1"}).count
    @rock_lost = rock_moves.count - @rock_won - @rock_ties
    @paper_won = paper_moves.where({:user_wins => "1"}).count
    @paper_ties = paper_moves.where({:tie => "1"}).count
    @paper_lost = paper_moves.count - @paper_won - @paper_ties
    @scissors_won = scissors_moves.where({:user_wins => "1"}).count
    @scissors_ties = scissors_moves.where({:tie => "1"}).count
    @scissors_lost = scissors_moves.count - @scissors_won - @scissors_ties

    @total_won = @rock_won + @paper_won + @scissors_won
    @total_lost = @rock_lost + @paper_lost + @scissors_lost
    @total_ties = @rock_ties + @paper_ties + @scissors_ties


  render("rps.html.erb")
  end


end
