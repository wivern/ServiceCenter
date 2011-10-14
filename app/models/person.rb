class Person < ActiveRecord::Base
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at

  def display_name
    name_parts = name.split
    if name_parts.size < 3
      name_parts.join(', ')
    else
      "#{name_parts[0]}, #{name_parts[1]} #{name_parts[2][0]}."
    end
  end
end
