class Admin::UnitsController < ApplicationController
  # GET /units
  # GET /units.xml
  def index
    @units = Unit.all

    if @units.blank?
      redirect_to new_admin_unit_path, notice: 'No measuring units were found. Create the first one now!'
    else
      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

  # GET /units/new
  # GET /units/new.xml
  def new
    @unit = Unit.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /units/1/edit
  def edit
    @unit = Unit.find(params[:id])
  end

  # POST /units
  # POST /units.xml
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to(admin_units_path, notice: 'Unit was successfully created.') }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /units/1
  # PUT /units/1.xml
  def update
    @unit = Unit.find(params[:id])

    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to(admin_units_path, notice: 'Unit was successfully updated.') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.xml
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to(admin_units_url) }
    end
  end

  private

  def unit_params
    params.require(:unit).permit(:name, :abbreviation, :size_in_ounces)
  end
end
