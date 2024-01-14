class User::ValueHistoriesController < User::BaseController
  before_action :set_invesment, only: %i[ show ]

  def index
    @invesment = Invesment.find(params[:invesment_id])
    @value_histories = @invesment.value_histories.newest
  end

  def new
    @invesment = Invesment.find(params[:invesment_id])
    @value_history = @invesment.value_histories.new
  end

  def show
  end

  def create
    @invesment = Invesment.find(params[:invesment_id])
    @value_history = @invesment.value_histories.build(invesment_params)

    respond_to do |format|
      if @value_history.save
        format.html { redirect_to user_invesment_path(@invesment), notice: "Value history was successfully created." }
        format.turbo_stream {
          flash[:notice] = 'Create value history successfully'
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_invesment
      @invesment = Invesment.find(params[:invesment_id])
      @value_history = @invesment.value_histories.find(params[:id])
    end

    def invesment_params
      params.require(:value_history).permit(:current_value)
    end
end
