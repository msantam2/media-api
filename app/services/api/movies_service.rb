module Api
  class MoviesService
    def call(genres_ref)
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

      persist(movies, genres_ref)
    end

    private

    def persist(movies, genres_ref)
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

      puts "Saving movie instances to your DB..."

      persisted_movie_count = 0
      movies.each { |movie| persisted_movie_count += 1 if movie.save }
      puts "#{persisted_movie_count} movies have been persisted to your database.".colorize(:green)
    end
  end
end
