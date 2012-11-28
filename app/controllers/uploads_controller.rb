class UploadsController < ApplicationController
  require 'rubygems'
  require 'nokogiri'

  #before_filter :authenticate_user!

  RECORDS = Hash.new
  KEYS = Array.new

  def index
    @uploads = Upload.all
  end

  def new
    @upload = Upload.new
  end

  
  def create

    # File as variable
    file = params[:upload][:file]
    # Upload directory
    directory = "public/uploads/"
    # Tempfile from file
    tmp = params[:upload][:file].tempfile
    # Set file and name as original name
    file = File.join(directory, params[:upload][:file].original_filename)
    # Copy temp file to file
    FileUtils.cp tmp.path, file

    # lees xml bestand
    f = File.open(file)
      doc = Nokogiri::XML(f)
    f.close

    # begin bij de root-node
    display_node_name(doc.xpath("./*").first)

    product_value = 0
    product_path = nil

    RECORDS.each do |record|
      if product_value < record[1]['count']
        product_value = record[1]['count']
        product_path  = record[1]['path']+'/'+record[0]
      end
    end

    feed = Feed.create(:xml_path => product_path  ,:feed_path => file)
    @feed_id = feed.id
    @fields = Field.all
  end

  def category
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

  def parse

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
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
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

          @categories = Category.new
        end
    end
    sub_nodes.map { |n| display_node_name(n, depth+1) } if sub_nodes.length > 0
  end
end