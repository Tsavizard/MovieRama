class VotesController < ApplicationController
  before_action :set_current_user
  before_action :set_movie, only: %i[ create destroy ]

  # POST /movies/:movie_id/votes
  def create
    @vote =  case params[:vote][:vote_type]
    when "like"
       @current_user.like(@movie)
    when "dislike"
      @current_user.dislike(@movie)
    else
      nil
    end

    if @vote
      redirect_to @movie, notice: "Vote was successfully created."
    else
      redirect_to @movie, alert: "Failed to create vote."
    end
  end

  # DELETE /movies/:movie_id/votes/:id
  def destroy
    @movie.votes.destroy_by(user: @current_user)
    redirect_to @movie, notice: "Vote was successfully deleted."
  end

  private

  def set_current_user
    @current_user ||= Current.session.user
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
