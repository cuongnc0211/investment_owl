module User::InvesmentsHelper
  def profit_class(invesment)
    invesment.profit_amount.positive? ? 'text-success' : 'text-danger'
  end
end
