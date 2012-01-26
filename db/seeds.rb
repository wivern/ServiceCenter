# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Commonly used currencies
Currency.seed(:char_code,
              {:name => 'руб.', :full_name => 'Российский рубль', :char_code => 'RUR', :num_code => 810},
              {:name => 'евро', :full_name => 'Европейское евро', :char_code => 'EUR', :num_code => 978},
              {:name => '$', :full_name => 'Доллар США', :char_code => 'USD', :num_code => 840}
)
# Person`s positions
positions = Position.seed_once( :name,
    {:name => 'Приемщик', :roles => [:inspector]},
    {:name => 'Сервис-инженер', :roles => [:engineer]},
    {:name => 'Администратор', :roles => [:administrator]},
    {:name => 'Директор', :roles => [:manager, :director]}
)
# Person`s statuses
PersonStatus.seed(:id,
                  {:id => 1, :name => 'Уволен', :prevent_sign_in => true},
                  {:id => 2, :name => 'Работает'},
                  {:id => 3, :name => 'В отпуске'},
                  {:id => 4, :name => 'Испытательный срок'}
)

position_admin = positions.select { |i| i.roles.include?(:administrator) }.first
# Default organization
organization = Organization.seed_once(:id, {:id => 1, :name => 'Наша организация'}).first
# Default administrator
Person.seed_once(:username, {:username => 'admin', :name => 'Administrator', :email => 'admin@example.com',
                             :password => 'Admin123', :password_confirmation => 'Admin123',
                             :organization => organization, :position => position_admin})
