class FeedsController < ApplicationController

  require 'rubygems'
  require 'nokogiri'

  # Authorisation
  load_and_authorize_resource


  before_filter :authenticate_user!

  RECORDS = Hash.new
  KEYS = Array.new

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(params[:feed])
    file = params[:file]
    directory = "public/uploads/"
    tmp = params[:file].tempfile
    file = File.join(directory, params[:file].original_filename)
    FileUtils.cp tmp.path, file
    @feed.feed_path = file
    @feed.status = 'created'
    respond_to do |format|
      if @feed.save
        format.html { redirect_to feeds_path, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def fields
    @feed = Feed.where({:status => 'user_fields', :id => params[:id]}).last
    @foreign_fields = DatafeedKey.where(:feed_id => @feed.id)
    @fields = Field.all
    if params[:commit]
      params[:keys].each do |key, value|
        newkey = DatafeedKey.where({:name => key, :feed_id => @feed.id}).last
        newkey.field_id = value
        newkey.save
      end
      @feed.status = 'active'
      @feed.save
      redirect_to feeds_path, notice: 'Feed was successfully created.' 
    end
  end

  def index
    @feeds = Feed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end
  
  def show
    @feed = Feed.find(params[:id])
    @products = Feed.find(params[:id]).products

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end

  def filter
    @feed_id = params[:id]
    if params[:commit]
      filter = Filter.new
      filter.save

      params[:fields].each do |field|
        option = Filteroption.new 
        option.name = 'field'
        option.value = field[0]
        option.filter_id = filter.id
        option.save
      end

      params[:categories].each do |category|
        option = Filteroption.new 
        option.name = 'category'
        option.value = category[0]
        option.filter_id = filter.id
        option.save
      end

      redirect_to :controller => :products, :action => :export, :format => :xml, :id => @feed_id, :filter => filter.id
    else
      @categories = Array.new
      @products = Product.where('feed_id' => @feed_id)
      @products.each do |product|
        @categories << product.category.name
      end
      @categories = @categories.uniq
      @fields = Field.all
    end
  end

  def display_node_name(node, depth = 0)
    sub_nodes = node.xpath("./*")
    if sub_nodes.length < 1
      KEYS << node.name
    else  
        if RECORDS[node.name].blank?
          RECORDS[node.name] = Hash.new
          RECORDS[node.name]['count'] = 1
          RECORDS[node.name]['path'] = node.parent.path()
        else 
          RECORDS[node.name]['count'] += 1
        end
        if sub_nodes.length > 1
          @listofitems = Hash.new
          @firstitem = Array.new
         
          sub_nodes.each do |l|
            # Values from array

            # Key names
            @firstitem << l.name

            @listofitems[l.name] = l.text 
          end
        end
    end
    sub_nodes.map { |n| display_node_name(n, depth+1) } if sub_nodes.length > 0
  end

end
