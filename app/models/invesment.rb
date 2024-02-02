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

  def profit_amount
    current_value - capital
  end

  def profit_percentage(rounding_digits = 2)
    (profit_amount / capital * 100.0).round(rounding_digits)
  end

  def transactions(limit = 5)
    list = Transaction.where("source_id = ? OR target_id = ?", self.id, self.id).newest.limit(limit)

    list.each do |t|
      t.transaction_type = (id == t.source_id) ? 'withdraw' : 'deposit'
    end

    list
  end

  def current_value
    value_histories.last&.current_value
  end

  def current_capital
    capital - withdraw_transactions.map(&:amount).sum + deposit_transactions.map(&:amount).sum
  end

  def capital_at(time = Time.zone.now)
    capital - withdraw_transactions.before(time).map(&:amount).sum + deposit_transactions.before(time).map(&:amount).sum
  end

  def value_at(time = Time.zone.now)
    value_histories.before(time).last&.current_value || capital_at(time) || current_value
  end
end
