class Position < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at, :roles
  validates_presence_of :name
  serialize :roles #, Array

  attr_accessible :name, :roles

  cattr_reader :available_roles
  @@available_roles = {
      :inspector => {:name => I18n.t('roles.inspector')},
      :engineer => {:name => I18n.t('roles.engineer')},
      :administrator => {:name => I18n.t('roles.administrator')},
      :manager => {:name => I18n.t('roles.manager')},
      :director => {:name => I18n.t('roles.director')},
      :analyst => {:name => I18n.t('roles.analyst')},
      :price_reader => {:name => I18n.t('roles.price_reader')}
  }

  def roles_names
    self.roles.select{|e|
      e && self.class.available_roles.has_key?(e.to_sym) }.map{|r|
        logger.debug "role: #{r}, available: #{self.class.available_roles.inspect}"
        self.class.available_roles[r.to_sym][:name] if r
      }.sort_by { |e| e }.join(', ') if self.roles
  end

  def roles
    if read_attribute(:roles)
      read_attribute(:roles).map(&:to_s)
    else
      []
    end
  end
end
