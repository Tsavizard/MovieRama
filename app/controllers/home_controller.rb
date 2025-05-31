class HomeController < ApplicationController
  allow_unauthenticated_access
  before_action :resume_session

  def index
    @movies = Movie.all
  end
end
