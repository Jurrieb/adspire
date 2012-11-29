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
  end

  def fetch_data
    file = params[:file]
    directory = "public/uploads/"
    tmp = params[:file].tempfile
    file = File.join(directory, params[:file].original_filename)
    FileUtils.cp tmp.path, file
    
    f = File.open(file)
      doc = Nokogiri::XML(f)
    f.close

    display_node_name(doc.xpath("./*").first)

    product_value = 0
    product_path = nil

    RECORDS.each do |record|
      if product_value < record[1]['count']
        product_value = record[1]['count']
        product_path  = record[1]['path']+'/'+record[0]
      end
    end

    feed = Feed.create(:name => params[:name],:url => params[:url],:xml_path => product_path  ,:feed_path => file)
    @feed_id = feed.id
    @fields = Field.all
  end

  def fetch_categories
    @feed_id = params[:feed_id]
    feed = Feed.find(@feed_id)

    categories = Array.new
    category_field = Field.where('name' => 'category').first
    category_key = nil
    params[:keys].each do |key, value|
      existingCategory = DatafeedKey.find(:first, :conditions => {:field_id => value})
       if existingCategory
          existingCategory.foreign_key_name = key;
          existingCategory.save
       else
         DatafeedKey.create(:field_id => value  ,:foreign_key_name => key)
       end
       if value.to_i == category_field.id
         category_key = key
       end
    end

    f = File.open(feed.feed_path)
      doc = Nokogiri::XML(f)
    f.close

    doc.xpath(feed.xml_path+'/*').each do |product|
      
      if product.name == category_key
        categories << product.text
      end

    end

    @selfCategories = Category.all
    @feedCategories = categories.uniq
  end

  def parse_data
    @feed_id = params[:feed_id]
    feed = Feed.find(@feed_id)

    params['keys'].each do |key, value|
      existingCategory = ForeignCategory.find(:first, :conditions => {:name => key})
       if existingCategory
          existingCategory.category_id = value;
          existingCategory.save
       else
         ForeignCategory.create(:category_id => value  ,:name => key)
       end
    end

    f = File.open(feed.feed_path)
      doc = Nokogiri::XML(f)
    f.close

    dont_use_field_id = Field.where('name' => 'Dont use').first
    records = DatafeedKey.where('field_id <> ?', dont_use_field_id.id)
    doc.xpath(feed.xml_path).each  do |product|
      products = Hash.new
      records.each do |record|
        if record.field.name == 'category'
          category = ForeignCategory.find_by_name(product.xpath(record.foreign_key_name).text)
          products['category_id'] = category.category_id
          products['feed_id'] = params[:feed_id]
        else
          products[record.field.name] = product.xpath(record.field.name).text
        end
      end
      Product.create(products)
    end
    redirect_to feeds_path
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
