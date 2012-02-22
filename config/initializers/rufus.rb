require 'rubygems'
require "rufus/scheduler"

scheduler = Rufus::Scheduler.start_new

ExchangeJob.all.each{|job|
  scheduler.cron job.value, :tags => job.id do
    job.execute if job.respond_to? :execute
  end rescue nil
}

Rails.configuration.scheduler = scheduler