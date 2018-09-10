# MOVIE GENRES
puts "Fetching movie genres..."

raw_genres = RestClient.get("#{ENV['THE_MOVIE_DB_MOVIE_GENRES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}" })

raw_genres = JSON.parse(raw_genres)
movie_genres_ref = {}

raw_genres["genres"].each do |genre|
  id = genre["id"]
  name = genre["name"]
  movie_genres_ref[id] = name  
end

puts "Done fetching movie genres.".colorize(:green)
puts



# SHOW GENRES
puts "Fetching TV show genres..."

raw_genres = RestClient.get("#{ENV['THE_MOVIE_DB_SHOW_GENRES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}" })

raw_genres = JSON.parse(raw_genres)
show_genres_ref = {}

raw_genres["genres"].each do |genre|
  id = genre["id"]
  name = genre["name"]
  show_genres_ref[id] = name  
end

puts "Done fetching TV show genres.".colorize(:green)
puts



# MOVIES
puts "Fetching the movies!..."

page_count = ENV['THE_MOVIE_DB_PAGE_COUNT'].to_i
movies = []

# note: the maximum page size is 20
page_count.times do |i|
  raw_movies = RestClient.get("#{ENV['THE_MOVIE_DB_MOVIES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}", primary_release_year: "#{ENV['THE_MOVIE_DB_MOVIES_RELEASE_YEAR']}", page: (i + 1) })

  raw_movies = JSON.parse(raw_movies)
  movies += raw_movies["results"]
end

puts "Done fetching movies.".colorize(:green)
puts

movies = movies.map do |movie|
  title = movie["title"]
  release_year = movie["release_date"].split("-").first.to_i
  synopsis = movie["overview"]

  genres = []
  genre_ids = movie["genre_ids"]
  genre_ids.each { |genre_id| genres << movie_genres_ref[genre_id] }
  genres = genres.join(", ")

  Api::Movie.new(title: title,
                 release_year: release_year,
                 synopsis: synopsis,
                 genres: genres)
end

puts "Saving movie instances to your DB..."

persisted_movie_count = 0
movies.each { |movie| persisted_movie_count += 1 if movie.save }
puts "#{persisted_movie_count} movies have been persisted to your database.".colorize(:green)



# SLEEP (in order to not exceed external API's requests/second quota)
puts
puts "taking a quick break! be back in 10 (seconds)...".colorize(:blue)
puts
sleep(10)



# SHOWS
puts "Fetching the TV shows!..."

page_count = ENV['THE_MOVIE_DB_PAGE_COUNT'].to_i
shows = []

# note: the maximum page size is 20
page_count.times do |i|
  raw_shows = RestClient.get("#{ENV['THE_MOVIE_DB_SHOWS_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}", first_air_date_year: "#{ENV['THE_MOVIE_DB_SHOWS_RELEASE_YEAR']}", page: (i + 1) })

  raw_shows = JSON.parse(raw_shows)
  shows += raw_shows["results"]
end

puts "Done fetching TV shows.".colorize(:green)
puts

shows = shows.map do |show|
  title = show["name"]
  release_year = show["first_air_date"].split("-").first.to_i
  synopsis = show["overview"]

  genres = []
  genre_ids = show["genre_ids"]
  genre_ids.each { |genre_id| genres << show_genres_ref[genre_id] }
  genres = genres.join(", ")

  Api::Show.new(title: title,
                release_year: release_year,
                synopsis: synopsis,
                genres: genres)
end

puts "Saving TV show instances to your DB..."

persisted_show_count = 0
shows.each { |show| persisted_show_count += 1 if show.save }
puts "#{persisted_show_count} shows have been persisted to your database.".colorize(:green)

puts

puts "Done!".colorize(:green)
