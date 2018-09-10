# GENRES
raw_genres = RestClient.get("#{ENV['THE_MOVIE_DB_GENRES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}" })

raw_genres = JSON.parse(raw_genres)

genres_ref = {}

raw_genres["genres"].each do |genre|
  id = genre["id"]
  name = genre["name"]

  genres_ref[id] = name  
end



# MOVIES
page_count = ENV['THE_MOVIE_DB_PAGE_COUNT'].to_i

movies = []

# note: the maximum page size is 20
page_count.times do |i|
  raw_movies = RestClient.get("#{ENV['THE_MOVIE_DB_MOVIES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}", primary_release_year: "#{ENV['THE_MOVIE_DB_MOVIES_RELEASE_YEAR']}", page: (i + 1) })

  raw_movies = JSON.parse(raw_movies)
  movies += raw_movies["results"]
end

movies = movies.map do |movie|
  title = movie["title"]
  release_year = movie["release_date"].split("-").first.to_i
  synopsis = movie["overview"]

  genres = []
  genre_ids = movie["genre_ids"]
  genre_ids.each { |genre_id| genres << genres_ref[genre_id] }
  genres = genres.join(", ")

  Api::Movie.new(title: title,
                 release_year: release_year,
                 synopsis: synopsis,
                 genres: genres)
end

persisted_movie_count = 0
movies.each { |movie| persisted_movie_count += 1 if movie.save }
puts "#{persisted_movie_count} movies have been persisted to your database."



# SLEEP (in order to not exceed external API's requests/second quota)
# sleep(10)



# SHOWS

