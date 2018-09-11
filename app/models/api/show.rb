module Api
  class Show < ApplicationRecord
    include PgSearch
    pg_search_scope :search_by_title, against: :title

    belongs_to :media_type
  end
end
