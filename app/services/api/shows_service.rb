module Api
  class ShowsService
    def call(genres_ref)
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

      persist(shows, genres_ref)
    end

    private

    def persist(shows, genres_ref)
      shows = shows.map do |show|
        title = show["name"]
        release_year = show["first_air_date"].split("-").first.to_i
        synopsis = show["overview"]
      
        genres = []
        genre_ids = show["genre_ids"]
        genre_ids.each { |genre_id| genres << genres_ref[genre_id] }
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
    end
  end
end
