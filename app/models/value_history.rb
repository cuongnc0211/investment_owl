class ValueHistory < ApplicationRecord
  belongs_to :invesment

  monetize :previous_value_cents, allow_nil: true
  monetize :current_value_cents

  scope :newest, -> { order(created_at: :desc) }
  scope :last_5, -> { order(created_at: :desc).limit(5) }

  delegate :currency, to: :invesment
end
