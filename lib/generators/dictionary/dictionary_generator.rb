require 'yaml'

class DictionaryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def generate_disctionary
     generate("model", "#{file_name} name:string")
  end
  def add_to_tree
    dict = YAML.load_file("#{RAILS_ROOT}/app/components/dictionaries.yml")
    dict ||= {}
    dict.merge! 'dictionaries' => {} unless dict.has_key? 'dictionaries'
    dict['dictionaries'].merge!({ "#{file_name}" => { 'text' => "activerecord.models.#{file_name}", 'leaf' => true,
                                                  'component' => "#{file_name}_component" } })
    dict.merge! 'components' => {} unless dict.has_key? 'components'
    dict['components'].merge!({ "#{file_name}_component" => {
        :class_name => "Basepack::GridPanel",
        :model => file_name.underscore.titleize,
        :lazy_loading => true,
        :title => file_name.underscore.humanize.pluralize,
        :persistance => true
    }})
    File.open("#{RAILS_ROOT}/app/components/dictionaries.yml", 'w'){ |f|
      YAML.dump(dict, f)
    }
  end
end
