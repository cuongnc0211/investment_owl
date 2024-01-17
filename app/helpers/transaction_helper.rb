
module TransactionHelper
  def transaction_formated_amount(transaction)
    binding.pry
    case transaction.transaction_type
    when 'deposit'
      "+ #{transaction.amount.format}"
    when 'withdraw'
      "- #{transaction.amount.format}"
    end
  end
end
