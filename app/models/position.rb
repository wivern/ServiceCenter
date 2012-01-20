class Position < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at, :roles
  validates_presence_of :name
  serialize :roles, Array

  attr_accessible :name, :roles

  cattr_reader :available_roles
  @@available_roles = {
      :inspector => { :name => I18n.t('roles.inspector') },
      :engineer  => { :name => I18n.t('roles.engineer') },
      :administrator => { :name => I18n.t('roles.administrator') },
      :manager => { :name => I18n.t('roles.manager') },
      :director => { :name => I18n.t('roles.director') }
  }

  def roles_names
    self.roles.select{|e| e}.
        map{|r| available_roles[r.to_sym][:name] if r}.sort_by{|e| e}.join(', ')
  end
end
