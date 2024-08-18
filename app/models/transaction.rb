class Transaction < ApplicationRecord
  belongs_to :source, class_name: 'Invesment', foreign_key: 'source_id', optional: true
  belongs_to :target, class_name: 'Invesment', foreign_key: 'target_id', optional: true

  attr_accessor :transaction_type

  monetize :amount_cents

  scope :newest, -> { order(created_at: :desc) }
  scope :last_5, -> { order(created_at: :desc).limit(5) }
  scope :before, ->(date) { where('created_at < ?', date) }
  scope :belong_to_invement, ->(invement) { where("source_id = ? OR target_id = ?", invement.id, invement.id) }

  delegate :currency, to: :source, prefix: false, allow_nil: true

  validate :enough_source_money

  private

  def enough_source_money
    return true if source.blank?

    errors.add(:amount, 'Not enough money') if source.current_capital < amount
  end
end
