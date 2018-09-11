module Api
  class MovieSerializer < ActiveModel::Serializer
    attributes :id, :title, :release_year, :synopsis, :genres, :media_type

    def media_type
      object.media_type.name
    end
  end
end
