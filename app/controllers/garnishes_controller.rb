class GarnishesController < ApplicationController
  before_action :set_garnish, only: [:edit, :update, :destroy]

  # GET /garnishes
  def index
    @garnishes = Garnish.all
  end

  # GET /garnishes/new
  def new
    @garnish = Garnish.new
  end

  # GET /garnishes/1/edit
  def edit
  end

  # POST /garnishes
  def create
    @garnish = Garnish.new(garnish_params)

    if @garnish.save
      redirect_to garnishes_path, notice: 'Garnish was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /garnishes/1
  def update
    if @garnish.update(garnish_params)
      redirect_to garnishes_path, notice: 'Garnish was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /garnishes/1
  def destroy
    @garnish.destroy
    redirect_to garnishes_path, notice: 'Garnish was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_garnish
      @garnish = Garnish.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def garnish_params
      params.require(:garnish).permit(:name)
    end
end
