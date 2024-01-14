class Invesment < ApplicationRecord
  STATUSES = %w[active inactive archived].freeze

  belongs_to :user

  has_many :value_histories, dependent: :destroy
  has_many :recent_5_values, -> { last_5 }, class_name: 'ValueHistory', inverse_of: :invesment
  has_many :withdraw_transactions, class_name: 'Transaction', foreign_key: 'source_id', inverse_of: :source
  has_many :recent_5_withdraw_transactions, -> { last_5 }, class_name: 'Transaction', foreign_key: 'source_id', inverse_of: :source
  has_many :deposit_transactions, class_name: 'Transaction', foreign_key: 'target_id', inverse_of: :target
  has_many :recent_5_deposit_transactions, -> { last_5 }, class_name: 'Transaction', foreign_key: 'target_id', inverse_of: :target

  enum status: STATUSES.zip(STATUSES).to_h

  scope :newest, -> { order(created_at: :desc) }

  monetize :capital_cents

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  accepts_nested_attributes_for :value_histories, allow_destroy: true

  def current_value
    value_histories.last&.current_value
  end
end
