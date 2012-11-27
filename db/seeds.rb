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

Field.create(name: "Dont use", visible: false)
Field.create(name: "name", visible: true)
Field.create(name: "description", visible: true)
Field.create(name: "category", visible: true)
Field.create(name: "image", visible: true)
Field.create(name: "url", visible: true)
Field.create(name: "price", visible: true)