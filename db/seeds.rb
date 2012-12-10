# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create(name: "bier")
Category.create(name: "fiets")
Category.create(name: "hond")
Category.create(name: "huis")
Category.create(name: "kat")
Category.create(name: "laptop")
Category.create(name: "gsm")

Field.create(name: "dont use", product_column_name: 'nil', visible: false)
Field.create(name: "unique hash", product_column_name: 'unique_hash', visible: true)
Field.create(name: "name", product_column_name: 'name', visible: true)
Field.create(name: "description", product_column_name: 'description', visible: true)
Field.create(name: "category", product_column_name: 'category_id', visible: true)
Field.create(name: "image", product_column_name: 'image', visible: true)
Field.create(name: "url", product_column_name: 'url', visible: true)
Field.create(name: "price", product_column_name: 'price', visible: true)
Field.create(name: "price old", product_column_name: 'price_old', visible: true)

Role.create(name: 'admin')
Role.create(name: 'user')
Role.create(name: 'affiliate')
Role.create(name: 'merchant')

u = User.new(
	:email => 'info@adspire.nl', 
	:password => 'test12', 
	:password_confirmation => 'test12'
)
u.save!(:validate => false)

User.find_by_email('info@adspire.nl').roles << Role.find_by_name('admin')
