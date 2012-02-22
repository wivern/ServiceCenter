#encoding: UTF-8

class ExchangeJob < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_presence_of :name, :value, :target_path
  after_save :reschedule
  before_destroy :unschedule

  def execute(params = {})
    begin
      do_execute
      update_attributes :latest_run => Time.now, :message => "Успешно завершено", :success => true
      save!
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace
      update_attributes :latest_run => Time.now, :message => e.message, :success => false
      save!
    end
  end

  protected
  def do_execute(params = {})
    #override it to do real job
  end

  def running?
    jobs = Rails.configuration.scheduler.find_by_tag id
    jobs.each{|k, job| return true if job and job.running? } unless jobs.empty?
    false
  end

  def reschedule
    return unless value_changed?
    logger.debug "Rescheduling for #{inspect}"
    scheduler = Rails.configuration.scheduler
    jobs = scheduler.find_by_tag id
    jobs.each{|job| job.unschedule } unless jobs.empty?
    scheduler.cron value, :tags => id do
      execute
    end rescue nil
    if Rails.env.development?
      logger.debug "Scheduled jobs:"
      scheduler.all_jobs.each{|key, job|
        logger.debug "#{job.cron_line.original} #{job.next_time} #{job.tags.inspect}"
      }
    end
  end

  def unschedule
    scheduler = Rails.configuration.scheduler
    jobs = scheduler.find_by_tag id
    jobs.each{|job| job.unschedule} unless jobs.empty?
  end

end
