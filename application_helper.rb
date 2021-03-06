# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

...

  # adds link to select filter
  # this passes the name and id fields of the object being filtered, to use different field names just change them as neccessary here
  def select_filter(action, category, filter, values)
    link_to "#{category.name} (#{values.length.to_s})", :action => action, :name => category.name, :id => category.id, :query=> @query, :filter => filter, :selected_filters => @selected_filters 
  end

  # adds link to remove filter
  def remove_filter(action, s, s_name, selected_filter)
    link_to s_name, {:action => action, :name => s_name, :id => s, :filter => selected_filter, :selected_filters => @selected_filters, :remove => true}, {:title=> "Remove this filter"}
  end

  #list of filters which user can click on to remove
  def display_remove_filters(results=[], selected_filters=[], action=:index)
    html=""    
    	
	if @conditions == ""
		html+="<h2>Refine your results</h2>"
    	else
    		html+="<h2>Selected Filters</h2>"
        	html+="<p>Click to remove</p>"

    		html+="<ul>"
			selected_filters.each do |selected_filter, selected|
  		
				selected.each do |s, s_name|
					html+="<li class='delete'>#{remove_filter(action, s, s_name, selected_filter)}</li>"
  				end
			end 

  		html+="</ul>"
	end
   
    #return list of filters to the view
    html

  end

  #headings for filtering down results
  def display_filter_headings(results=[], filters=[], selected_filters=[], action=:index)

    html="" 
   
    if results.length > 1 
  	filters.each do |filter, filter_heading|
         
		html+="<h3>#{split_and_camel(filter.to_s)}</h3>"

		filter_heading.each do |category, values|
      			html+="<ul>"

      			category.each do |c|
        		
				if !selected_filters[filter.to_s].has_key?(c.id.to_s)

          				html+="<li>#{select_filter(action, c, filter, values)}</li>"

        			end
      			end
        
			html+="</ul>"
    		end 
    	end
     end 

    #return the list to display in view
    html

  end

  #converts filter heading in order to display in view
  def split_and_camel(string)
     string.split("_").map{|word| word.camelize}.join(' ')
  end


...

end
