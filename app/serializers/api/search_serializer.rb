module Api
  class SearchSerializer < ActiveModel::Serializer
    attributes :id, :title, :release_year, :media_type

    def media_type
      id = object.media_type_id
      Api::MediaType.find_by_id(id).name
    end
  end
end
