class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :database_authenticatable, :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :remember_me, :organization,
        :position
  validates_presence_of :name, :organization, :position
  netzke_exclude_attributes :created_at, :updated_at, :password, :password_confirmation
  belongs_to :position
  belongs_to :organization
  belongs_to :person_status

  delegate :roles, :to => :position

  def active_for_authentication?
    super && !fired?
  end

  def fired?
    person_status && person_status.prevent_sign_in
  end

  def display_name
    name_parts = name.split
    if name_parts.size < 3
      name_parts.join(', ')
    else
      "#{name_parts[0]}, #{name_parts[1]} #{name_parts[2][0]}."
    end
  end

  def method_missing(method_name, *args)
    if match = matches_dynamic_role_check?(method_name)
      tokenize_roles(match.captures.first).each{|role|
          logger.debug "checking #{role} in #{roles.inspect}"
          return true if roles.include?(role.downcase.to_s)
      }
      return false
    else
      super
    end
  end

  #private
  def matches_dynamic_role_check?(method_name)
    /^has_role_([a-zA-Z]\w*)\?$/.match(method_name.to_s)
  end

  def tokenize_roles(roles_candidates)
    roles_candidates.split(/_or_/)
  end

end
