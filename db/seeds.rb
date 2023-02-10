# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   product = Product.create(title: 'Radio', description:'Esto es un ejemplo', price:1000)
# product.save

10.times do |i|
    Product.create(title: "Producto #{i}", description: "Description completa #{i}",price: 2*i)
  end