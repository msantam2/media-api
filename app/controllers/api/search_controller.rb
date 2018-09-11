module Api
  class SearchController < ApplicationController
    def index
      title = params[:query]
      movies = Api::Movie.search_by_title(title)
      shows = Api::Show.search_by_title(title)

      result = movies + shows
      return unless result.present?

      paginate json: result,
               each_serializer: Api::SearchSerializer
    end
  end
end
