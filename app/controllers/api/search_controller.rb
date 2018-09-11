module Api
  class SearchController < ApplicationController
    def index
      title = params[:query]
      movies = Api::Movie.search_by_title(title).includes(:media_type)
      shows = Api::Show.search_by_title(title).includes(:media_type)

      result = movies + shows
      return unless result.present?

      paginate json: result,
               each_serializer: Api::SearchSerializer
    end
  end
end
