module Api
  class SearchSerializer < ActiveModel::Serializer
    attributes :id, :title, :release_year, :media_type

    def media_type
      object.media_type.name
    end
  end
end
