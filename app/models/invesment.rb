class Invesment < ApplicationRecord
  STATUSES = %w[active inactive archived].freeze

  belongs_to :user

  enum status: STATUSES.zip(STATUSES).to_h
end
