require 'redmine'

Redmine::Plugin.register :redmine_default_columns do
  name 'Default columns'
  author 'Vitaly Klimov'
  author_url 'mailto:vvk@snowball.ru'
  description 'Plugin allows to apply default queries for individual project or for projects based on their type.'
  version '0.0.2'
  
  settings(:partial => 'settings/default_columns_settings',
           :default => {
             'query_templates_project_id' => '0',
             'type_custom_field_name' => 'Type',
             'default_query_name' => 'Default'
           })
  

end
