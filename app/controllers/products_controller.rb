class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  
  
  def index
    @products = Product.all(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end

  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def export
    @user_hash = params[:user_id]
    if params[:filter].blank?
      if Feed.exists?(params[:id])
        @fields = Array.new
        Field.all.each do |field|
          @fields << field.name
        end
        @products = Product.where({:feed_id => params[:id]})
      else
        abort('CANNOT FIND FEED')
      end
    else
      @fields = Array.new
      category_ids = Array.new
      if Filter.exists?(params[:filter])
        filter = Filter.find(params[:filter])
        filter.filteroptions.each do |option| 
          if option.name == 'category'
            category_ids << Category.find_by_name(option.value).id
          elsif option.name == 'field'
            @fields << option.value
          end
        end
        @products = Product.where({:feed_id => params[:id],:category_id => category_ids}) 
      else
        abort('CANNOT FIND FEED')
      end
    end
  end

end