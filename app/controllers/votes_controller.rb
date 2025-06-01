class VotesController < ApplicationController
  before_action :set_current_user
  before_action :set_movie, only: %i[ create update destroy ]

  # POST /movies/:movie_id/votes
  def create
    @vote = @movie.votes.new(vote_params)
    @vote.user = @current_user

    if @vote.save
      redirect_to @movie, notice: "Vote was successfully created."
    else
      redirect_to @movie, alert: "Failed to create vote."
    end
  end

  # PATCH /movies/:movie_id/votes
  def update
    @vote = @movie.votes.find_by(user: @current_user)
    if @vote&.update(vote_params)
      redirect_to @movie, notice: "Vote was successfully updated."
    else
      redirect_to @movie, alert: "Failed to update vote."
    end
  end

  # DELETE /movies/:movie_id/votes/:id
  def destroy
    @vote = @movie.votes.find_by(user: @current_user)
    if @vote&.destroy
      redirect_to @movie, notice: "Vote was successfully deleted."
    else
      redirect_to @movie, alert: "Failed to delete vote."
    end
  end

  private

  def set_current_user
    @current_user ||= Current.session.user
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def vote_params
    params.expect(vote: [ :vote_type ])
  end
end
