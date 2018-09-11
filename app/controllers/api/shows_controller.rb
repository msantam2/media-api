module Api
  class ShowsController < ApplicationController
    def show
      id = params[:id]
      result = Api::Show.find_by_id(id)

      return unless result.present?

      render json: result
    end
  end
end
