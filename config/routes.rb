ActionController::Routing::Routes.draw do |map|
  map.connect 'query_per_project/redirect_to_user_query', :controller => 'query_per_project', :action => 'redirect_to_user_query'
end
