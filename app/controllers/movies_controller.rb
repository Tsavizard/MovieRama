class MoviesController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  before_action :set_current_user
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @movies = Movie.all
    @movies = @movies.where(user_id: params[:user_id]) if params[:user_id].present?

    case params[:sort]
    when "likes"
      @movies = @movies
      .left_outer_joins(:votes)
      .select("movies.*", "COUNT(*) FILTER (WHERE movie_votes.vote_type = 'like') AS likes_count")
      .group("movies.id")
      .order(likes_count: :desc)
    when "dislikes"
      @movies = @movies
      .left_outer_joins(:votes)
      .select("movies.*", "COUNT(*) FILTER (WHERE movie_votes.vote_type = 'dislike') AS dislikes_count")
      .group("movies.id")
      .order(dislikes_count: :desc)
    when "date"
      @movies = @movies.order(created_at: :asc)
    else
      @movies = @movies.order(created_at: :desc)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = @current_user.movies.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = @current_user.movies.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_current_user
      @current_user ||= Current.session&.user
    end

    def set_movie
      @movie = @current_user.movies.find(params[:id])
    end

    def movie_params
      params.expect(movie: [ :title, :description ])
    end
end
