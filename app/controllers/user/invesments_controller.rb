class User::InvesmentsController < User::BaseController
  before_action :set_invesment, only: %i[ show edit update destroy ]

  def index
    @invesments = Invesment.all.newest
  end

  def show
  end

  def new
    @invesment = Invesment.new
  end

  def edit
  end

  def create
    @invesment = current_user.invesments.build(invesment_params)
    binding.pry

    respond_to do |format|
      if @invesment.save
        format.html { redirect_to user_invesment_url(@invesment), notice: "Invesment was successfully created." }
        format.turbo_stream {
          flash[:notice] = 'Create invesment successfully'
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invesment.update(invesment_params)
        format.html { redirect_to user_invesment_url(@invesment), notice: "Invesment was successfully updated." }
        format.turbo_stream {
          flash[:notice] = 'Update invesment successfully'
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invesment.destroy!

    respond_to do |format|
      format.html { redirect_to user_invesments_url, notice: "Invesment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_invesment
      @invesment = current_user.invesments.find(params[:id])
    end

    def invesment_params
      params.require(:invesment).permit(:name, :description, :status, :capital, value_histories_attributes: [:current_value])
    end
end
