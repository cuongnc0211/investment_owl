class ValueHistory < ApplicationRecord
  belongs_to :invesment

  scope :newest, -> { order(created_at: :desc) }
end
