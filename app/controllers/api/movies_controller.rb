module Api
  class MoviesController < ApplicationController
    def show
      id = params[:id]
      result = Api::Movie.find_by_id(id)

      return unless result.present?

      render json: result
    end
  end
end
