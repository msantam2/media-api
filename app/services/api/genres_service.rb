module Api
  class GenresService
    def initialize(media_type)
      case media_type
      when :movies
        @url = ENV['THE_MOVIE_DB_MOVIE_GENRES_URL']
      when :shows
        @url = ENV['THE_MOVIE_DB_SHOW_GENRES_URL']
      end
    end

    def call
      raw_genres = RestClient.get(@url, params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}" })

      raw_genres = JSON.parse(raw_genres)
      genres_ref = {}

      raw_genres["genres"].each do |genre|
        id = genre["id"]
        name = genre["name"]
        genres_ref[id] = name  
      end

      genres_ref
    end
  end
end
