xml.instruct!
xml.products do
  @products.each do |product|
    xml.product do
      @fields.each do |field|
        case field 
        when 'name'
          xml.name product[:name]
        when 'description'
          xml.description product[:description]
        when 'url'
          xml.url 'http://adspire.nl/clicks/'+@user_hash+'/'+product.id.to_s
        when 'price'
          xml.price product[:price]
        when 'price_old'
          xml.price_old product[:price_old]
        when 'image'
          xml.image product[:image]
        when 'category'
          xml.category product.category.name
        end
      end  
    end
  end
end