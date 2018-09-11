# MOVIE GENRES
puts "Fetching movie genres..."

movie_genres_ref = Api::GenresService.new(:movies).call

puts "Done fetching movie genres.".colorize(:green)
puts


# SHOW GENRES
puts "Fetching TV show genres..."

show_genres_ref = Api::GenresService.new(:shows).call

puts "Done fetching TV show genres.".colorize(:green)
puts


# MOVIES
Api::MoviesService.new.call(movie_genres_ref)


# SLEEP (in order to not exceed external API's requests/second quota)
puts
puts "taking a quick break! be back in 10 (seconds)...".colorize(:blue)
puts
sleep(10)


# SHOWS
Api::ShowsService.new.call(show_genres_ref)


puts
puts "Done!".colorize(:green)
