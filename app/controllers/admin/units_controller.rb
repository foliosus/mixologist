class Admin::UnitsController < ApplicationController
  # GET /units
  # GET /units.xml
  def index
    @units = Unit.all

    if @units.blank?
      redirect_to new_admin_unit_path, notice: 'No measuring units were found. Create the first one now!'
    end
  end

  # GET /units/new
  # GET /units/new.xml
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
    @unit = Unit.find(params[:id])
  end

  # POST /units
  # POST /units.xml
  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to admin_units_path, notice: 'Unit was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /units/1
  # PUT /units/1.xml
  def update
    @unit = Unit.find(params[:id])

    if @unit.update(unit_params)
      redirect_to admin_units_path, notice: 'Unit was updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /units/1
  # DELETE /units/1.xml
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy

    redirect_to admin_units_url, notice: "#{@unit.name.capitalize} unit has been deleted"
  end

  private

  def unit_params
    params.require(:unit).permit(:name, :abbreviation, :size_in_ounces)
  end
end
