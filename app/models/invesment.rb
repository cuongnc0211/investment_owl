class Invesment < ApplicationRecord
  STATUSES = %w[active inactive archived].freeze

  belongs_to :user

  has_many :value_histories, dependent: :destroy

  enum status: STATUSES.zip(STATUSES).to_h

  scope :newest, -> { order(created_at: :desc) }

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :capital_cents, presence: true, numericality: { greater_than: 0 }

  accepts_nested_attributes_for :value_histories, allow_destroy: true
end
