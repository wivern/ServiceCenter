require 'service_center'

namespace :sc do
  namespace :export do
    desc 'Export orders to xml'
    task :orders => :environment do
      file = ENV['DIR']
      unless file
        puts "Use: rake sc:export:orders DIR=your_directory"
        exit
      end
      ServiceCenter::Export::Orders.export_to_directory file
      puts "Export finished"
    end
  end
end