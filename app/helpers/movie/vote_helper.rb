module Movie::VoteHelper
  # Generates a button for voting on a movie or a span if already voted.
  # @param user [User] the user who is voting
  # @param movie [Movie] the movie being voted on
  # @param vote_type [Vote] the type of vote, either "like" or "dislike"
  def vote_link(user, movie, vote_type)
    text = vote_type == "like" ? "like" : "hate"
    method = vote_type == "like" ? :likes : :dislikes
    return tag.span("#{pluralize(movie.send(method).size, text)}", class: "votes") if user.nil?


    if user.send("#{method}?", movie) or user.has_submitted?(movie)
      tag.span "#{pluralize(movie.send(method).size, text)}", class: "votes"
    else
      link_to "#{pluralize(movie.send(method).size, text)}", movie_votes_path(movie.id), class: "votes", data: { turbo_method: :post }
    end
  end
end
