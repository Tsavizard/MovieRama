# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
#
usernames = [ "Cersei Lannister", "Jaime Lannister", "Tyrion Lannister", "Tywin Lannister", "Daenerys Targaryen", "Jon Snow", "Eddard Stark", "Bronn", "Sandor Clegane" ]
usernames.each do |username|
  User.find_or_create_by!(username: username) do |user|
    user.email = "#{username.downcase.gsub(' ', '_')}@movierama_game_of_thrones.com"
    user.password = "password"
    user.password_confirmation = "password"
  end
end

# Create default user
User.find_or_create_by!(email: "demo@movierama_game_of_thrones.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.username = "Demo User"
  user.email_address = "demo@movierama_game_of_thrones.com"
end

movies_data = [
  { title: "The Shawshank Redemption", description: "Banker gets framed for his wife's murder, gets imprisoned and tries to escape" },
  { title: "The Godfather", description: "Marlon Brando stars as the Godfather, a mob boss" },
  { title: "The Dark Knight", description: "Overhyped Batman movie" },
  { title: "Pulp Fiction", description: "The adventures of Samuel L Jackson and John Travolta as the henchmen of a mobster" },
  { title: "The Lord of the Rings: The Return of the King", description: "Final movie of the masterpiece trilogy by JRR Tolkien" },
  { title: "Forrest Gump", description: "Good natured Forrest, Tom Hanks" },
  { title: "Inception", description: "Movie about dream in a dream in a dream" },
  { title: "Fight Club", description: "Edward Norton and Brad Pitt star in an anti-consumerism and anti-conformist movie. Edward meets Brad and start an underground fighting ring" },
  { title: "The Matrix", description: "Keannu Reaves is an accountant by day hacker by night, until he meets Trinity and discovers reality is a computer program" },
  { title: "Goodfellas", description: "Haven't seen this movie" },
  { title: "The Silence of the Lambs", description: "Haven't seen this movie, Thriller about serial killer Hannibal Lecter, starring Antony Hopkins and Jodie Foster" },
  { title: "Schindler's List", description: "Oscar Schindler, a successful and narcissistic German businessman, slowly starts worrying about the safety of his Jewish workforce after witnessing their persecution in Poland during World War II" },
  { title: "The Departed", description: "Haven't seen this movie" },
  { title: "Gladiator", description: "Commodus takes over power and demotes Maximus, one of the preferred generals of his father, Emperor Marcus Aurelius. As a result, Maximus is relegated to fighting till death as a gladiator." },
  { title: "The Social Network", description: "Haven't seen this movie" },
  { title: "Interstellar", description: "The earth is trashed and humanity is looking for the solution in space. Matthew McConaughey goes " },
  { title: "The Prestige", description: "Haven't seen this movie" },
  { title: "The Usual Suspects", description: "Haven't seen this movie" },
  { title: "Se7en", description: "Haven't seen this movie" },
  { title: "Braveheart", description: "Haven't seen this movie" },
  { title: "The Green Mile", description: "Prisoners facing death row, racist guard tortures black inmate sentenced to electric chair" }
]

users = User.all
movies_data.each do |movie_data|
  Movie.find_or_create_by!(title: movie_data[:title]) do |movie|
    movie.description = movie_data[:description]
    movie.user = users[rand(users.size)] # Assign a random user to the movie
  end
end

movies = Movie.all

users.each do |user|
  movies.each do |movie|
    if user.movies.include?(movie)
      # User has already voted on this movie, skip to the next one
      next
    end

    random_vote = rand(3) # 0, 1, or 2
    case random_vote
    when 0
      # User likes the movie
      user.likes.find_or_create_by!(movie: movie)
    when 1
      # User dislikes the movie
      user.dislikes.find_or_create_by!(movie: movie)
    when 2
      # User has no opinion on the movie, do nothing
      next
    end
  end
end
