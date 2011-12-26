class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :database_authenticatable, :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :remember_me
  validates_presence_of :name, :organization
  netzke_exclude_attributes :created_at, :updated_at, :password, :password_confirmation
  belongs_to :position
  belongs_to :organization

  def display_name
    name_parts = name.split
    if name_parts.size < 3
      name_parts.join(', ')
    else
      "#{name_parts[0]}, #{name_parts[1]} #{name_parts[2][0]}."
    end
  end

end
