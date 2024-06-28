class Admin::GarnishesController < ApplicationController
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
    @garnish = Garnish.find(params[:id])
  end

  # POST /garnishes
  def create
    @garnish = Garnish.new(garnish_params)

    if @garnish.save
      redirect_to admin_garnishes_path, notice: 'Garnish was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /garnishes/1
  def update
    @garnish = Garnish.find(params[:id])
    if @garnish.update(garnish_params)
      redirect_to admin_garnishes_path, notice: 'Garnish was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /garnishes/1
  def destroy
    @garnish = Garnish.find(params[:id])
    @garnish.destroy
    redirect_to admin_garnishes_path, notice: "#{@garnish.name.capitalize} garnish was successfully destroyed"
  end

  # Only allow a trusted parameter "white list" through.
  private def garnish_params
    params.require(:garnish).permit(:name)
  end
end
