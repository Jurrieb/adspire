class FeedsController < ApplicationController

  require 'rubygems'
  require 'nokogiri'

  # Authorisation
  load_and_authorize_resource


  before_filter :authenticate_user!

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(params[:feed])
    if params[:file]
      file = params[:file]
      directory = "public/uploads/"
      tmp = params[:file].tempfile
      file = File.join(directory, params[:file].original_filename)
      FileUtils.cp tmp.path, file
      @feed.feed_path = file
    end
    @feed.user_id = current_user.id
    @feed.status = 'created'
    respond_to do |format|
      if @feed.save
        format.html { redirect_to own_feeds_path, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def fields
    @feed = Feed.where({:status => ['user_fields', 'active'], :id => params[:id]}).last
    if @feed 
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
        redirect_to own_feeds_path, notice: 'Feed was successfully created.' 
      end
    else
      redirect_to own_feeds_path, notice: 'Velden kunnen niet worden aangepast.' 
    end
  end

  def categories
    @feed = Feed.where({:status => 'active', :id => params[:id]}).last   
    if @feed
      @foreign_categories = ForeignCategory.where(:feed_id => @feed.id)  
      @categories = Category.all    
      if params[:commit]
        params[:categories].each do |key, value|    
          newkey = ForeignCategory.where({:name => key, :feed_id => @feed.id}).last
          newkey.category_id = value
          newkey.save
        end  
        redirect_to own_feeds_path, notice: 'Categories where successfully saved.'    
        @feed.status = 'active'  
        @feed.save  
      end
    else
      redirect_to own_feeds_path, notice: 'Categorien kunnen niet worden aangepast.' 
    end
  end

  def index
    @feeds = Feed.find(:all, :conditions => {:status => 'active'}) 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  def index_own
    @feeds = Feed.find(:all, :conditions => {:user_id => current_user.id}) 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to own_feeds_path, notice: 'Feed was successfully updated.' }
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
      format.html { redirect_to own_feeds_path }
      format.json { head :no_content }
    end
  end

  def filter
    @feed_id = params[:id]
    if @feed_id
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

        redirect_to :controller => :products, :action => :export, :format => :xml, :id => @feed_id,:user_id => current_user.id, :filter => filter.id
      else
        @categories = Array.new
        @products = Product.where('feed_id' => @feed_id)
        @products.each do |product|
          if !product.category.blank?
            @categories << product.category.name
          end
        end
        @categories = @categories.uniq
        @fields = Field.all
      end
    else
      redirect_to :controller => :feeds, :action => :index
    end
  end
end