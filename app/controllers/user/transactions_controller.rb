class User::TransactionsController < User::BaseController

  def index
    @invesment = Invesment.find_by(id: params[:invesment_id])

    @pagy, @transactions = pagy(Transaction.belong_to_invement(@invesment).newest, items: 1)
    Invesment.setup_transaction_type(@transactions, @invesment)
  end

  def new
    source = Invesment.find_by(id: params[:source_id])
    target = Invesment.find_by(id: params[:target_id])

    @transaction = Transaction.new(source: source, target: target)
  end


  def create
    @transaction = Transaction.build(transaction_params)

    respond_to do |format|
      if create_transaction(@transaction, @transaction.source, @transaction.target)
        user_invesments =  current_user.invesments.includes(:value_histories).active.newest

        @chart_data = ::HomeChartDataProcess.call(invesments: user_invesments).data
        @invesments = [@transaction.source, @transaction.target].compact

        format.html { redirect_to user_transaction_url(@transaction), notice: "Transaction was successfully created." }
        format.turbo_stream {
          flash[:notice] = 'Create transaction successfully'
        }
      else
        flash.now[:danger] = "Create transaction failed: #{@transaction.errors.full_messages.join(', ')}"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

    def transaction_params
      params.require(:transaction).permit(:source_id, :target_id, :amount, :note)
    end

    def create_transaction(transaction, source, target)
      ActiveRecord::Base.transaction do
        # create transaction and update current_value of the investment
        transaction.save!

        # update source
        if source.present?
          source.value_histories.create!(
            current_value: source.current_value - transaction.amount,
            previous_value: source.current_value
          )
        end

        # update target
        if target.present?
          target.value_histories.create!(
            current_value: target.current_value + transaction.amount,
            previous_value: target.current_value
          )
        end
      end

      true
    rescue StandardError => e
      transaction.errors.add(:base, e.message)
      return false
    end
end
