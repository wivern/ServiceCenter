# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Currency.create([
    {:name => 'руб.', :full_name => 'Российский рубль', :char_code => 'RUR', :num_code => 810},
    {:name => 'евро', :full_name => 'Европейское евро', :char_code => 'EUR', :num_code => 978},
    {:name => '$', :full_name => 'Доллар США', :char_code => 'USD', :num_code => 840}
                ])

Person.create({:username => 'admin', :name => 'Administrator', :email => 'admin@example.com',
              :password => 'Admin123', :password_confirmation => 'Admin123'})