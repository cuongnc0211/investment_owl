class ValueHistory < ApplicationRecord
  belongs_to :invesment

  monetize :previous_value_cents, allow_nil: true
  monetize :current_value_cents

  scope :newest, -> { order(id: :desc) }
  scope :last_5, -> { limit(5) }
  scope :before, ->(date) { where('created_at < ?', date) }

  delegate :currency, to: :invesment
end
