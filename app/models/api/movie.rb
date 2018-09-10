module Api
  class Movie < ApplicationRecord
    belongs_to :media_type
  end
end
