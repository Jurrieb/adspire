class ControllersController < ApplicationController
  # GET /controllers
  # GET /controllers.json
  def index
    @controllers = Controller.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @controllers }
    end
  end

  # GET /controllers/1
  # GET /controllers/1.json
  def show
    @controller = Controller.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @controller }
    end
  end

  # GET /controllers/new
  # GET /controllers/new.json
  def new
    @controller = Controller.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @controller }
    end
  end

  # GET /controllers/1/edit
  def edit
    @controller = Controller.find(params[:id])
  end

  # POST /controllers
  # POST /controllers.json
  def create
    @controller = Controller.new(params[:controller])

    respond_to do |format|
      if @controller.save
        format.html { redirect_to @controller, notice: 'Controller was successfully created.' }
        format.json { render json: @controller, status: :created, location: @controller }
      else
        format.html { render action: "new" }
        format.json { render json: @controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /controllers/1
  # PUT /controllers/1.json
  def update
    @controller = Controller.find(params[:id])

    respond_to do |format|
      if @controller.update_attributes(params[:controller])
        format.html { redirect_to @controller, notice: 'Controller was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @controller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controllers/1
  # DELETE /controllers/1.json
  def destroy
    @controller = Controller.find(params[:id])
    @controller.destroy

    respond_to do |format|
      format.html { redirect_to controllers_url }
      format.json { head :no_content }
    end
  end
end
