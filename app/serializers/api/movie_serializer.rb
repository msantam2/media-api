module Api
  class MovieSerializer < ActiveModel::Serializer
    attributes :id, :title, :release_year, :synopsis, :genres, :media_type

    def media_type
      id = object.media_type_id
      Api::MediaType.find_by_id(id).name
    end
  end
end
