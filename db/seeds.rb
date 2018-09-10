# genres
raw_genres = RestClient.get("#{ENV['THE_MOVIE_DB_GENRES_URL']}", params: { api_key: "#{ENV['THE_MOVIE_DB_API_KEY']}" })

raw_genres = JSON.parse(raw_genres)

genres = {}

raw_genres["genres"].each do |genre|
  id = genre["id"]
  name = genre["name"]

  genres[id] = name  
end

# movies


# shows

# make the above a class! (would be a service object!)

