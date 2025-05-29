class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @movies = Movie.all
  end
end
