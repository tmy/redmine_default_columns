require 'redmine'
require_dependency 'issues_controller'

class IssuesController < ApplicationController

  # Retrieve query from session or build a new query
	def retrieve_query_with_default_query
		if should_apply_for_default_query?
  		get_default_query
 			retrieve_query_without_default_query unless @query
		else
			retrieve_query_without_default_query
		end
	end

	alias_method_chain :retrieve_query, :default_query

private

	def should_apply_for_default_query?
		return false unless params[:query_id].blank?
		if (params[:set_filter] || session[:query].nil? || 
			   	session[:query][:project_id] != (@project ? @project.id : nil))
			return true
	  end
		return false
	end
	
  def get_default_query
    @query = nil
    if params[:set_filter].nil? and @project
    	query_default_name = Setting.plugin_redmine_default_columns['default_query_name']
      @query = Query.find_by_name(query_default_name, :conditions => "project_id = #{@project.id}")
      if !@query
      	prj = Project.find_by_id(Setting.plugin_redmine_default_columns['query_templates_project_id'])
        if prj
          template_str = "Project"
          custom_name = Setting.plugin_redmine_default_columns['type_custom_field_name']
          @project.custom_values.each do |custom_value|
            if custom_value.custom_field.name == custom_name and !custom_value.value.blank?
              template_str = custom_value.value.to_s.strip
              break
            end
          end
          template_str = "Default_" + template_str
          @query = Query.find_by_name(template_str, :conditions => "project_id = #{prj.id}" )
        end
      end
      
      if @query
        @query = @query.clone
        @query.project = @project
        @query.project_id = @project.id
        session[:query] = {:project_id => @query.project_id, :filters => @query.filters, :group_by => @query.group_by, :column_names => @query.column_names}
      end
    end
  end

end

