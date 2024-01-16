class User::TransactionsController < User::BaseController

  def index
    @transactions = Transaction.all.newest
  end

  def new
    source = Invesment.find_by(id: params[:source_id])
    target = Invesment.find_by(id: params[:target_id])

    @transaction = Transaction.new(source: source, target: target)
  end


  def create
    @transaction = Transaction.build(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to user_transaction_url(@transaction), notice: "Transaction was successfully created." }
        format.turbo_stream {
          flash[:notice] = 'Create transaction successfully'
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

    def transaction_params
      params.require(:transaction).permit(:source_id, :target_id, :amount, :note)
    end
end