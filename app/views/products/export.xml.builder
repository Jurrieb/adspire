xml.instruct!
xml.products do
  @products.each do |product|
    xml.product do
      @fields.each do |field|
        case field 
        when 'name'
          xml.name "<![CDATA["+product[:name].to_s+"]]>"
        when 'description'
          xml.description "<![CDATA["+product[:description].to_s+"]]>"
        when 'url'
          xml.url "<![CDATA["+request.env['HTTP_HOST']+url_for(:controller => 'clicks', :action => 'create',:user_id => @user_hash, :product_id => product.id.to_s)+"]]>"
        when 'price'
          xml.price "<![CDATA["+product[:price].to_s+"]]>"
        when 'price_old'
          xml.price_old "<![CDATA["+product[:price_old].to_s+"]]>"
        when 'image'
          xml.image "<![CDATA["+product[:image].to_s+"]]>"
        when 'category'
          if !product.category.blank?
            xml.category "<![CDATA["+product.category.name+"]]>"
          end
        end
      end  
    end
  end
end

